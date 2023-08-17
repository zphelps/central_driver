import 'package:central_driver/types/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/services/services.dart';
import '../main.dart';

class ServicesState {
  final String truckID;
  final String date;
  final bool loading;
  final List<Service> services;

  ServicesState({
    required this.truckID,
    required this.date,
    this.loading = false,
    this.services = const [],
  });
}

class ServicesStateNotifier extends StateNotifier<ServicesState> {
  ServicesStateNotifier() : super(ServicesState(truckID: '', date: DateTime.now().toIso8601String()));

  void setTruckID(String truckID) async {
    state = ServicesState(truckID: truckID, date: state.date, loading: true);
    final services = await ServiceApi().getServices(truckID: truckID, date: state.date);
    state = ServicesState(truckID: truckID, date: state.date, services: services, loading: false);
  }

  void setDate(String date) async {
    state = ServicesState(truckID: state.truckID, date: date, loading: true);
    final services = await ServiceApi().getServices(truckID: state.truckID, date: date);
    state = ServicesState(truckID: state.truckID, date: date, services: services, loading: false);
  }

  void refresh() async {
    final services = await ServiceApi().getServices(truckID: state.truckID, date: state.date);
    state = ServicesState(truckID: state.truckID, date: state.date, services: services, loading: false);
  }
}

final servicesStateProvider = StateNotifierProvider<ServicesStateNotifier, ServicesState>((ref) {
  return ServicesStateNotifier();
});