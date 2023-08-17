import 'package:central_driver/types/service.dart';
import 'package:central_driver/views/service-flow/service-flow.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import '../../api/services/services.dart';

class ServiceInstructions extends StatefulWidget {
  final String serviceID;

  const ServiceInstructions({required this.serviceID, super.key});

  @override
  State<ServiceInstructions> createState() => _ServiceInstructionsState();
}

class _ServiceInstructionsState extends State<ServiceInstructions> {
  Service? service;

  Future fetchService() async {
    dynamic res = await ServiceApi().getService(id: widget.serviceID);
    setState(() {
      service = res;
    });
  }

  @override
  initState() {
    super.initState();
    fetchService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Flow', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[50],
        toolbarHeight: 45,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Driver Instructions',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please review the following instructions before beginning service.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                service == null
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          service?.driver_notes ?? 'No instructions provided.',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                const SizedBox(height: 75)
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () async {
                  try {
                    await ServiceApi().updateStep(widget.serviceID, 1);
                    context
                        .flow<ServiceFlowState>()
                        .update((profile) => profile.copyWith(step: 1));
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
