import 'dart:async';

import 'package:central_driver/types/service.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '../../api/services/services.dart';
import '../../widgets/services/details_card.dart';
import '../service-flow/service-flow.dart';

class ServiceDetails extends StatefulWidget {
  final Service initialService;
  const ServiceDetails({super.key, required this.initialService});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  late EasyRefreshController controller;
  late Timer timer;
  late Service service;

  bool _beginningService = false;

  Future fetchWorkOrder() async {
    dynamic res = await ServiceApi().getService(id: widget.initialService.id);
    // if (res != null && res.status =='in-progress') {
    //   //await Navigator.of(context).push(ServiceFlow.route(res.id));
    // } else {
    //   setState(() {
    //     service = res;
    //   });
    // }
    setState(() {
      service = res;
    });
  }

  @override
  void initState() {
    super.initState();
    service = widget.initialService;
    controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Text(service.job.service_type.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[500])),
            const SizedBox(height: 5),
            Text(service!.client.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18)),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: EasyRefresh(
        controller: controller,
        header: const ClassicHeader(),
        footer: const ClassicFooter(),
        onRefresh: () async {
          await fetchWorkOrder();
          if (!mounted) {
            return;
          }
          controller.finishRefresh();
          controller.resetFooter();
        },
        onLoad: () async {
          await fetchWorkOrder();
          if (!mounted) {
            return;
          }
          controller.finishLoad(IndicatorResult.success);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          children: [
            service!.completed_on != null ? _workOrderCompleteCard(context) : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if(service.status != 'in-progress') {
                              setState(() {
                                _beginningService = true;
                              });
                              try {
                                await ServiceApi().beginService(service.id);
                                await fetchWorkOrder();
                              } catch (e) {
                                setState(() {
                                  _beginningService = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Text('Error beginning service. Please try again.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                ));
                                return;
                              }
                              setState(() {
                                _beginningService = false;
                              });
                            }
                            await Navigator.of(context).push(ServiceFlow.route(service.id));
                            await controller.callRefresh();
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                          ),
                          child: _beginningService ? const CupertinoActivityIndicator(color: Colors.white, radius: 12.5) : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.handyman_outlined, color: Colors.white),
                              const SizedBox(width: 10),
                              Text(service.status == 'in-progress' || service.status == 'incomplete' ? 'Resume' : 'Begin Service'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.grey[200],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call_outlined, color: Colors.black),
                              SizedBox(width: 10),
                              Text(
                                'Contact Client',
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        MapsLauncher.launchQuery(service.location.formatted_address);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Error launching maps. Please try again.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                        ));
                        return;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.grey[200],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_outlined, color: Colors.black),
                        SizedBox(width: 10),
                        Text(
                          'Navigate to Client',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ServiceDetailsCard(service: service!)
          ],
        ),
      ),
    );
  }


  Widget _workOrderCompleteCard(context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 45,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service Complete',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                        formatDate(DateTime.parse(service!.completed_on!), ['DD', ', ', 'M', ' ', 'd', ', ', 'yyyy', ' at ', 'h', ':', 'nn', ' ', 'am']),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}