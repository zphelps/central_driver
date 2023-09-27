import 'package:central_driver/types/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../main.dart';
import '../../types/service_report.dart';

final servicesApiProvider = Provider<ServiceApi>((ref) {
  return ServiceApi();
});

final serviceStateStreamProvider = StreamProvider.family<ServiceState, String>((ref, serviceID) {
  return ref.watch(servicesApiProvider).serviceStateStream(serviceID);
});

class ServiceState {
  const ServiceState({
    required this.step,
    required this.currentBinID,
  });

  final int step;
  final String? currentBinID;
}

class ServiceApi {
  Future beginService(String serviceID) async {
    try {
      await supabase
          .from('client_services')
          .update({
            'step': 0,
            'status': 'in-progress',
          })
          .eq('id', serviceID);
      await supabase
          .from('organizational_users')
          .update({
            'current_service_id': serviceID,
          })
          .eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      throw StateError("Error beginning service: ${e.toString()}");
    }
  }

  Future exitService(String serviceID) async {
    try {
      await supabase
          .from('client_services')
          .update({
            'status': 'incomplete',
            'step': 3
          })
          .eq('id', serviceID);
      await supabase
          .from('organizational_users')
          .update({
            'current_service_id': null,
          })
          .eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      throw StateError("Error exiting service: ${e.toString()}");
    }
  }

  Future completeService(String serviceID) async {
    try {
      //get service
      final service = await supabase
          .from('client_services')
          .select('id, job:job_id(*)')
          .eq('id', serviceID)
          .single();

      print(service);

      // get bins
      final bins = await supabase
          .from('service_bins')
          .select('id, initial_fill_level, final_fill_level')
          .eq('service_id', serviceID);

      double? num_units_to_charge = null;

      if (service['job']['charge_unit'] == '% Compacted') {
        num_units_to_charge = 0.0;
        for (var bin in bins) {
          final perCompacted = (bin['initial_fill_level'] as int) - (bin['final_fill_level'] as int);
          num_units_to_charge = num_units_to_charge! + (perCompacted / 100);
        }
      } else if (service['job']['charge_unit'] == 'Bin') {
        num_units_to_charge = bins.length + 0.0;
      } else if (service['job']['charge_unit'] == 'Hour') {
        num_units_to_charge = (service['duration'] as int) / 60;
      }

      print(num_units_to_charge);

      await supabase
          .from('client_services')
          .update({
            'step': 3,
            'status': 'completed',
            'completed_on': DateTime.now().toIso8601String(),
            'num_units_to_charge': num_units_to_charge,
          })
          .eq('id', serviceID);
      await supabase
          .from('organizational_users')
          .update({
            'current_service_id': null,
          })
          .eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      throw StateError("Error completing service: ${e.toString()}");
    }
  }

  Future updateStep(String serviceReportID, int step) async {
    try {
      final prevStep = await supabase
          .from('client_services')
          .select('step')
          .eq('id', serviceReportID)
          .single();
      if (prevStep['step'] > step) return;
      await supabase
          .from('client_services')
          .update({'step': step})
          .eq('id', serviceReportID);
    } catch (e) {
      throw StateError("Error updating step: ${e.toString()}");
    }
  }

  Future updateService(String serviceID, Map<String, dynamic> data) async {
    try {
      await supabase
          .from('client_services')
          .update(data)
          .eq('id', serviceID);
    } catch (e) {
      throw StateError("Error updating service: ${e.toString()}");
    }
  }

  Future setBinImagePath(
      {required String binID, required String imageColumnID, required String imagePath}) async {
    try {
      await supabase
          .from('service_bins')
          .update({imageColumnID: imagePath})
          .eq('id', binID);
    } catch (e) {
      throw StateError("Error updating image path: ${e.toString()}");
    }
  }

  Stream<ServiceState> serviceStateStream(String reportID) {
    return supabase
        .from('client_services')
        .stream(primaryKey: ['id'])
        .eq('id', reportID)
        .limit(1)
        .map((event) => ServiceState(
              step: event.first['step'],
              currentBinID: event.first['current_bin_id'],
            ));
  }

  Future<List<Service>> getServices(
      {required String truckID, required String date}) async {
    final now = DateTime.parse(date);
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final res = await supabase
        .from('client_services')
        .select('*, '
            'location:location_id(*), '
            'job:job_id(*, service_type), '
            'client:client_id(*), '
            'on_site_contact:on_site_contact_id(*), '
            'organization:organization_id(*), '
            'truck:truck_id(*, driver:driver_id(*))')
        .eq('organization.id',
            supabase.auth.currentUser!.userMetadata!['organization_id'])
        .eq('franchise_id',
            supabase.auth.currentUser!.userMetadata!['franchise_id'])
        .eq('truck_id', truckID)
        .gte('timestamp', startOfDay.toUtc())
        .lte('timestamp', endOfDay.toUtc())
        .order('timestamp', ascending: true);
    if (res == null) {
      throw StateError("Error fetching services");
    } else {
      return res.map<Service>((e) {
        print(e['client']);
        return Service.fromMap(e);
      }).toList();
    }
  }

  Future<Service> getService({
    required String id,
  }) async {
    final res = await supabase
        .from('client_services')
        .select('*, '
        'location:location_id(*), '
        'job:job_id(*, service_type), '
        'client:client_id(*), '
        'on_site_contact:on_site_contact_id(*), '
        'organization:organization_id(*), '
        'truck:truck_id(*, driver:driver_id(*))')
        .eq('id', id)
        .single();
    if (res == null) {
      throw StateError("Error fetching work orders");
    } else {
      return Service.fromMap(res);
    }
  }
}
