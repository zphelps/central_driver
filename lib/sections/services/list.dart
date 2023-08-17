import 'dart:async';
import 'package:central_driver/state/services.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/services/list_card.dart';


class ServicesList extends ConsumerStatefulWidget {
  const ServicesList({super.key});

  @override
  ConsumerState<ServicesList> createState() => _WorkOrdersState();
}

class _WorkOrdersState extends ConsumerState<ServicesList> {
  dynamic servicesState;
  late EasyRefreshController controller;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    controller = EasyRefreshController();
    timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      controller.callRefresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    servicesState = ref.watch(servicesStateProvider);
    if (servicesState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return EasyRefresh(
      controller: controller,
      header: const ClassicHeader(
        position: IndicatorPosition.above,
        processedDuration: Duration(milliseconds: 500),
      ),
      onRefresh: () async {
        ref.read(servicesStateProvider.notifier).refresh();
      },
      child: servicesState.services.isEmpty ? ListView(
        children: const [
          SizedBox(height: 90),
          Image(
            image: AssetImage('assets/empty.png'),
            height: 150,
          ),
          SizedBox(height: 30),
          Text(
            'No services found',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ) : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: servicesState.services.length,
        itemBuilder: (context, index) {
          return ServiceListTile(service: servicesState.services[index]);
        },
      )
    );
  }
}
