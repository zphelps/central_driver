import 'package:central_driver/views/service-bin-flow/review_bin.dart';
import 'package:central_driver/views/service-bin-flow/service_checklist_1.dart';
import 'package:central_driver/views/service-bin-flow/service_checklist_2.dart';
import 'package:central_driver/views/service-bin-flow/service_checklist_3.dart';
import 'package:central_driver/views/service-bin-flow/service_checklist_4.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import 'bin_photos.dart';
import 'final_fill_level.dart';
import 'initial_fill_level.dart';

class ServiceBinFlowState {
  const ServiceBinFlowState({
    required this.step,
  });

  final int step;

  ServiceBinFlowState copyWith({int? step}) {
    return ServiceBinFlowState(
      step: step ?? this.step,
    );
  }
}

class ServiceBinFlow extends ConsumerStatefulWidget {
  final String serviceID;
  final String binID;
  const ServiceBinFlow({required this.serviceID, required this.binID, super.key});

  static Route<ServiceBinFlowState> route(String serviceID, String binID) {
    return MaterialPageRoute(builder: (_) => ServiceBinFlow(serviceID: serviceID, binID: binID));
  }

  @override
  ConsumerState<ServiceBinFlow> createState() => _ServiceBinFlowState();
}

class _ServiceBinFlowState extends ConsumerState<ServiceBinFlow> {
  bool hasReNavigated = false;

  @override
  Widget build(BuildContext context) {
    final binAsyncValue = ref.watch(binStreamProvider(widget.binID));
    return Scaffold(
      body: SafeArea(
        child: binAsyncValue.when(
          data: (bin) {
            return FlowBuilder<ServiceBinFlowState>(
              state: ServiceBinFlowState(step: bin.step ?? 0),
              onGeneratePages: (serviceFlowState, pages) {
                if (serviceFlowState.step == 8 && !hasReNavigated) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                  hasReNavigated = true;
                }

                return [
                  if (serviceFlowState.step == 0) MaterialPage(child: ServiceChecklist1(binID: bin.id)),
                  if (serviceFlowState.step >= 1) MaterialPage(child: BinPhotos(bin: bin)),
                  if (serviceFlowState.step >= 2) MaterialPage(child: ServiceChecklist2(binID: bin.id)),
                  if (serviceFlowState.step >= 3) MaterialPage(child: InitialFillLevel(serviceID: widget.serviceID, bin: bin)),
                  if (serviceFlowState.step >= 4) MaterialPage(child: ServiceChecklist3(binID: bin.id)),
                  if (serviceFlowState.step >= 5) MaterialPage(child: FinalFillLevel(serviceID: widget.serviceID, bin: bin)),
                  if (serviceFlowState.step >= 6) MaterialPage(child: ServiceChecklist4(binID: bin.id)),
                  if (serviceFlowState.step >= 7) MaterialPage(child: ReviewBin(serviceID: widget.serviceID, bin: bin)),
                ];
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) {
            return Center(child: Text('Error with realtime connection: ${error.toString()} ${stackTrace.toString()}'));
          },
        ),
      ),
    );
  }
}
