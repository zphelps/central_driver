
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart';
import '../../types/bin.dart';
import '../services/services.dart';

final binsApiProvider = Provider<BinsApi>((ref) {
  return BinsApi();
});

final serviceBinsStreamProvider = StreamProvider.family<List<Bin>, String>((ref, serviceID) {
  return ref.watch(binsApiProvider).getServiceBinsStream(serviceID);
});

final binStreamProvider = StreamProvider.family<Bin, String>((ref, binID) {
  return ref.watch(binsApiProvider).getBinStream(binID);
});

class BinsApi {
  Stream<List<Bin>> getServiceBinsStream(String serviceID) {
    return supabase
        .from('service_bins')
        .stream(primaryKey: ['id'])
        .eq('service_id', serviceID)
        .order('created_at', ascending: true)
        .map((event) => event.map((e) => Bin.fromMap(e)).toList());
  }

  Stream<Bin> getBinStream(String binID) {
    return supabase
        .from('service_bins')
        .stream(primaryKey: ['id'])
        .eq('id', binID)
        .map((event) => Bin.fromMap(event.first));
  }

  Future addBin(String serviceID) async {
    try {
      final data = await supabase
          .from('service_bins')
          .insert({
            'service_id': serviceID,
            'organization_id': supabase.auth.currentUser!.userMetadata!['organization_id'],
            'franchise_id': supabase.auth.currentUser!.userMetadata!['franchise_id'],
            'step': 0,
          }).select().single();
      await ServiceApi().updateService(
          serviceID,
          {
            'current_bin_id': data['id'],
          }
      );
    } catch (e) {
      throw StateError("Error adding bin: ${e.toString()}");
    }
  }

  Future deleteBin(String binID) async {
    try {
      await supabase
          .from('client_services')
          .update({
            'current_bin_id': null,
          })
          .eq('current_bin_id', binID);
      await supabase
          .from('service_bins')
          .delete()
          .eq('id', binID);
    } catch (e) {
      throw StateError("Error deleting bin: ${e.toString()}");
    }
  }

  Future updateStep(String binID, int step) async {
    try {
      final prevStep = await supabase
          .from('service_bins')
          .select('step')
          .eq('id', binID)
          .single();
      if (prevStep['step'] > step) return;
      await supabase
          .from('service_bins')
          .update({'step': step})
          .eq('id', binID);
    } catch (e) {
      throw StateError("Error updating step: ${e.toString()}");
    }
  }

  Future updateBin(String binID, Map<String, dynamic> data) async {
    try {
      await supabase
          .from('service_bins')
          .update(data)
          .eq('id', binID);
    } catch (e) {
      throw StateError("Error updating bin: ${e.toString()}");
    }
  }
}