import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../types/truck.dart';

final trucksServiceProvider = Provider<TrucksApi>((ref) {
  return TrucksApi();
});

final trucksStreamProvider = StreamProvider<List<Truck>>((ref) {
  return ref.watch(trucksServiceProvider).trucksStream();
});

class TrucksApi {
  Future<List<Truck>> getTrucks() async {
    final res = await supabase
        .from('trucks')
        .select('*, driver:driver_id(*)')
        .eq('organization_id',
        supabase.auth.currentUser!.userMetadata!['organization_id'])
        .eq('franchise_id',
        supabase.auth.currentUser!.userMetadata!['franchise_id']);

    if (res == null) {
      throw StateError("Error fetching work orders");
    } else {
      return res.map<Truck>((e) {
        return Truck.fromMap(e);
      }).toList();
    }
  }

  Stream<List<Truck>> trucksStream() {
    return supabase
        .from('trucks')
        .stream(primaryKey: ['id'])
        .eq('organization_id',
            supabase.auth.currentUser!.userMetadata!['organization_id'])
        .map((event) {
          return event.map((e) => Truck.fromMap(e)).toList();
        });
  }
}
