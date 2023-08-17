import 'package:central_driver/views/service-bin-flow/service-bin-flow.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';

class ServiceChecklist4 extends StatefulWidget {
  final String binID;
  const ServiceChecklist4({required this.binID, super.key});

  @override
  State<ServiceChecklist4> createState() => _ServiceChecklist4State();
}

class _ServiceChecklist4State extends State<ServiceChecklist4> {
  bool _loading = false;
  bool _nextEnabled = false;

  void updateNextEnabled() {
    setState(() {
      _nextEnabled = check1 && check2 && check3 && check4 && check5 && check6 && check7 && check8;
    });
  }

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  bool check5 = false;
  bool check6 = false;
  bool check7 = false;
  bool check8 = false;

  @override
  Widget build(BuildContext context) {
    updateNextEnabled();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[50],
        toolbarHeight: 45,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            context
                .flow<ServiceBinFlowState>()
                .update((profile) => profile.copyWith(step: 5));
          },
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 8),
            icon: const Icon(Icons.close),
            onPressed: () {
              showPlatformDialog(
                context: context,
                builder: (c) => PlatformAlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('This bin will be deleted.'),
                  actions: <Widget>[
                    PlatformDialogAction(child: PlatformText('Cancel'), onPressed: () => Navigator.pop(c)),
                    PlatformDialogAction(
                      child: PlatformText('Exit', style: const TextStyle(color: Colors.red)),
                      onPressed: () async {
                        Navigator.pop(c);
                        setState(() {
                          _loading = true;
                        });
                        await BinsApi().updateStep(widget.binID, 8);
                        await BinsApi().deleteBin(widget.binID);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Checklist',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete the following checklist before proceeding to the next step.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          CheckboxListTile(
                            title: const Text('Raise boom'),
                            value: check1,
                            onChanged: (value) {
                            setState(() {
                              check1 = value!;
                            });
                          }),
                          CheckboxListTile(
                            title: const Text('Lock'),
                            value: check2,
                            onChanged: (value) {
                            setState(() {
                              check2 = value!;
                            });
                          }),
                          CheckboxListTile(
                            title: const Text('Slide to front'),
                            value: check3,
                            onChanged: (value) {
                            setState(() {
                              check3 = value!;
                            });
                          }),
                          CheckboxListTile(
                            title: const Text('Lower boom'),
                            value: check4,
                            onChanged: (value) {
                            setState(() {
                              check4 = value!;
                            });
                          }),
                          CheckboxListTile(
                            title: const Text('Put chocks & chains in truck'),
                            value: check5,
                            onChanged: (value) {
                            setState(() {
                              check5 = value!;
                            });
                          }),
                          CheckboxListTile(
                            title: const Text('Get back in Cab'),
                            value: check6,
                            onChanged: (value) {
                            setState(() {
                              check6 = value!;
                            });
                          }),
                          CheckboxListTile(
                              title: const Text('Turn PTO off'),
                              value: check7,
                              onChanged: (value) {
                                setState(() {
                                  check7 = value!;
                                });
                              }),
                          CheckboxListTile(
                              title: const Text('Release parking brake'),
                              value: check8,
                              onChanged: (value) {
                                setState(() {
                                  check8 = value!;
                                });
                              }),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _nextEnabled ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      if (!_nextEnabled) return;
                      setState(() {
                        _loading = true;
                      });
                      try {
                        await BinsApi().updateStep(widget.binID, 7);
                        context
                            .flow<ServiceBinFlowState>()
                            .update((profile) => profile.copyWith(step: 7));
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: _loading
                ? Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
