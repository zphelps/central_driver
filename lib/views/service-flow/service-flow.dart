import 'package:central_driver/types/service.dart';
import 'package:central_driver/views/service-bin-flow/review_bin.dart';
import 'package:central_driver/views/service-bin-flow/service_checklist_1.dart';
import 'package:central_driver/views/service-flow/service-bins.dart';
import 'package:central_driver/views/service-flow/service-instructions.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/services/services.dart';
import '../service-bin-flow/service-bin-flow.dart';

class ServiceFlowState {
  const ServiceFlowState({
    required this.step,
  });

  final int step;

  ServiceFlowState copyWith({int? step}) {
    return ServiceFlowState(
      step: step ?? this.step,
    );
  }
}

class ServiceFlow extends ConsumerStatefulWidget {
  final String serviceID;
  const ServiceFlow({required this.serviceID, super.key});

  static Route<ServiceFlowState> route(String serviceID) {
    return MaterialPageRoute(builder: (_) => ServiceFlow(serviceID: serviceID), fullscreenDialog: true);
  }

  @override
  ConsumerState<ServiceFlow> createState() => _ServiceFlowState();
}

class _ServiceFlowState extends ConsumerState<ServiceFlow> {
  bool hasReNavigated = false;

  @override
  Widget build(BuildContext context) {
    final serviceAsyncValue = ref.watch(serviceStateStreamProvider(widget.serviceID));
    return Scaffold(
      body: SafeArea(
        child: serviceAsyncValue.when(
          data: (state) {
            if (state.currentBinID != null && !hasReNavigated) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(ServiceBinFlow.route(widget.serviceID, state.currentBinID!));
              });
              hasReNavigated = true;
            } else {
              hasReNavigated = false;
            }
            if (state.step == 3) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
              hasReNavigated = true;
            }

            return FlowBuilder<ServiceFlowState>(
              state: ServiceFlowState(step: state.step),
              onGeneratePages: (serviceFlowState, pages) {
                return [
                  if (serviceFlowState.step == 0) MaterialPage(child: ServiceInstructions(serviceID: widget.serviceID)),
                  if (serviceFlowState.step >= 1) MaterialPage(child: ServiceBins(serviceID: widget.serviceID)),
                  // if (serviceFlowState.step >= 3) MaterialPage(child: FinalFillLevel(workOrderID: widget.workOrderID, serviceReport: serviceReport)),
                  // if (serviceFlowState.step >= 4) MaterialPage(child: ReviewService(workOrderID: widget.workOrderID, serviceReport: serviceReport)),
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
