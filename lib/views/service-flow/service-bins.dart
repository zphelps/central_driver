import 'package:central_driver/types/service.dart';
import 'package:central_driver/views/service-flow/service-flow.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../widgets/service/select_fill_percentage.dart';

class ServiceBins extends ConsumerStatefulWidget {
  final String serviceID;

  const ServiceBins({required this.serviceID, super.key});

  @override
  ConsumerState<ServiceBins> createState() => _ServiceBinsState();
}

class _ServiceBinsState extends ConsumerState<ServiceBins> {
  bool _loading = false;
  bool _nextEnabled = false;

  @override
  Widget build(BuildContext context) {
    final serviceBinsAsyncValue =
        ref.watch(serviceBinsStreamProvider(widget.serviceID));
    return Scaffold(
      appBar: AppBar(
        title: Text('SER-${widget.serviceID.split('-')[0].toUpperCase()}', style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[50],
        toolbarHeight: 45,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context
                .flow<ServiceFlowState>()
                .update((profile) => profile.copyWith(step: 0));
          },
        ),
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
                      'Service Bins',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Click 'Add Bin' to add a bin to this service.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    serviceBinsAsyncValue.when(
                      data: (serviceBins) {
                        if(serviceBins.isEmpty) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),
                                Icon(
                                  Icons.hourglass_empty,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No bins added yet.',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade500,
                                  )
                                ),
                                const SizedBox(height: 30),
                              ]
                            ),
                          );
                        };
                        if(serviceBins.isNotEmpty) {
                          _nextEnabled = true;
                        }
                        return Expanded(
                          child: ListView.builder(
                            itemCount: serviceBins.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Bin #${index + 1}',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: serviceBins[index].ready_for_haul ?? false
                                                  ? Colors.red.shade100
                                                  : Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              serviceBins[index].ready_for_haul ?? false
                                                  ? 'HAUL NEEDED'
                                                  : 'RECEIVE MORE TRASH',
                                              style:
                                              TextStyle(color: serviceBins[index].ready_for_haul ?? false
                                                  ? Colors.red
                                                  : Colors.green, fontSize: 12, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      SelectFillPercentage(finalFill: false, bin: serviceBins[index]),
                                                  fullscreenDialog: true));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Initial Fill',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${serviceBins[index].initial_fill_level ?? '0'}%',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (_) =>
                                                      SelectFillPercentage(finalFill: true, bin: serviceBins[index]),
                                                  fullscreenDialog: true));
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Final Fill',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${serviceBins[index].final_fill_level ?? '0'}%',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      InkWell(
                                        onTap: () async {
                                          showPlatformDialog(
                                            context: context,
                                            builder: (c) => PlatformAlertDialog(
                                              title: const Text('Are you sure?'),
                                              content: const Text('This bin will be deleted.'),
                                              actions: <Widget>[
                                                PlatformDialogAction(child: PlatformText('Cancel'), onPressed: () => Navigator.pop(c)),
                                                PlatformDialogAction(
                                                  child: PlatformText('Delete', style: const TextStyle(color: Colors.red)),
                                                  onPressed: () async {
                                                    Navigator.pop(c);
                                                    setState(() {
                                                      _loading = true;
                                                    });
                                                    await BinsApi().deleteBin(serviceBins[index].id);
                                                    setState(() {
                                                      _loading = false;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey.shade300, width: 1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons.delete,
                                                  size: 16,
                                                  color: Colors.grey.shade500
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade600
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      loading: () =>
                          const Center(child: Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: CircularProgressIndicator(),
                          )),
                      error: (e, s) => Center(child: Text(e.toString())),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _loading = true;
                        });
                        try {
                          await BinsApi().addBin(widget.serviceID);
                          await ServiceApi().updateStep(widget.serviceID, 2);
                          setState(() {
                            _loading = false;
                          });
                          context
                              .flow<ServiceFlowState>()
                              .update((profile) => profile.copyWith(step: 2));
                        } catch (e) {
                          setState(() {
                            _loading = false;
                          });
                          print(e);
                        }

                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: Colors.grey.shade600
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add Bin',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600
                              ),
                            ),
                          ],
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
                        await ServiceApi().completeService(widget.serviceID);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Service Completed!',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17)),
                        ));
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        _loading = false;
                      });
                    },
                    child: const Text('Finish Service'),
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
