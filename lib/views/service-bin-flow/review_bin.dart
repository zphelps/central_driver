import 'package:central_driver/views/service-bin-flow/service-bin-flow.dart';
import 'package:central_driver/widgets/service/select_fill_percentage.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../main.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';
import '../camera/camera.dart';

class ReviewBin extends StatefulWidget {
  final String serviceID;
  final Bin bin;

  const ReviewBin({required this.serviceID, required this.bin, super.key});

  @override
  State<ReviewBin> createState() => _ReviewBinState();
}

class _ReviewBinState extends State<ReviewBin> {
  bool _nextEnabled = false;
  String? initialSignedURL;
  String? finalSignedURL;
  bool _completingService = false;

  void updateNextEnabled() {
    setState(() {
      _nextEnabled = widget.bin.initial_fill_level != null &&
          widget.bin.final_fill_level != null &&
          widget.bin.initial_fill_image != null &&
          widget.bin.final_fill_image != null;
    });
  }

  Future _getSignedURLs(String initialPath, String finalPath) async {
    final urls = await supabase.storage
        .from(supabase.auth.currentUser!.userMetadata!['organization_id'])
        .createSignedUrls([initialPath, finalPath], 3600);
    setState(() {
      initialSignedURL = urls[0].signedUrl;
      finalSignedURL = urls[1].signedUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateNextEnabled();
    if ((initialSignedURL == null || finalSignedURL == null) &&
        (widget.bin.initial_fill_image != null ||
            widget.bin.final_fill_image != null)) {
      _getSignedURLs(
          widget.bin.initial_fill_image!, widget.bin.final_fill_image!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bin',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                .update((profile) => profile.copyWith(step: 6));
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
                          _completingService = true;
                        });
                        await BinsApi().updateStep(widget.bin.id, 8);
                        await BinsApi().deleteBin(widget.bin.id);
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
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              const Text(
                'Review Bin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Confirm the information below is accurate.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: initialSignedURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                Image.network(
                                  initialSignedURL!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                Positioned(
                                    child: IconButton(
                                  icon: const Icon(Icons.restart_alt,
                                      color: Colors.white, size: 50),
                                  onPressed: () async {
                                    final url = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => Camera(
                                                showOverlay: true,
                                                binID: widget.bin.id,
                                                imageColumnID:
                                                    'initial_fill_image',
                                                imagePath:
                                                    'compaction_images/before/${widget.serviceID}'),
                                            fullscreenDialog: true));
                                    setState(() {
                                      initialSignedURL = url;
                                    });
                                  },
                                ))
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              final url = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => Camera(
                                          showOverlay: true,
                                          binID: widget.bin.id,
                                          imageColumnID: 'initial_fill_image',
                                          imagePath:
                                              'compaction_images/before/${widget.serviceID}'),
                                      fullscreenDialog: true));
                              setState(() {
                                initialSignedURL = url;
                              });
                            },
                            child: widget.bin.initial_fill_image != null
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: const Center(child: CircularProgressIndicator()))
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 55,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        ' Tap to take photo',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: finalSignedURL != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                Image.network(
                                  finalSignedURL!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                Positioned(
                                    child: IconButton(
                                  icon: const Icon(Icons.restart_alt,
                                      color: Colors.white, size: 50),
                                  onPressed: () async {
                                    final url = await Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (_) => Camera(
                                                showOverlay: true,
                                                binID: widget.bin.id,
                                                imageColumnID:
                                                    'final_fill_image',
                                                imagePath:
                                                    'compaction_images/after/${widget.serviceID}'),
                                            fullscreenDialog: true));
                                    setState(() {
                                      finalSignedURL = url;
                                    });
                                  },
                                ))
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              final url = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => Camera(
                                          showOverlay: true,
                                          binID: widget.bin.id,
                                          imageColumnID: 'final_fill_image',
                                          imagePath:
                                              'compaction_images/after/${widget.serviceID}'),
                                      fullscreenDialog: true));
                              setState(() {
                                finalSignedURL = url;
                              });
                            },
                            child: widget.bin.final_fill_image != null
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: const Center(child: CircularProgressIndicator()))
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 55,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        ' Tap to take photo',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _serviceCompletionDetailsCard(),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _nextEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              onPressed: () async {
                if (!_nextEnabled) return;

                try {
                  setState(() {
                    _completingService = true;
                  });
                  await BinsApi().updateBin(widget.bin.id, {
                    'ready_for_haul':
                        (widget.bin.final_fill_level ?? 0) < 95 ? false : true,
                    'step': 8,
                  });
                  await ServiceApi().updateService(widget.serviceID, {
                    'current_bin_id': null,
                    'step': 1,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Bin Added!',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17)),
                  ));
                  setState(() {
                    _completingService = false;
                  });
                } catch (e) {
                  print(e);
                  setState(() {
                    _completingService = false;
                  });
                }
              },
              child: const Text('Add Bin'),
            ),
          ),
          _completingService
              ? Positioned.fill(
                  child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(child: CircularProgressIndicator())))
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _serviceCompletionDetailsCard() {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        SelectFillPercentage(finalFill: false, bin: widget.bin),
                    fullscreenDialog: true));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INITIAL FILL LEVEL',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.bin.initial_fill_level == null
                            ? 'NOT SET'
                            : '${widget.bin.initial_fill_level.toString()}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.bin.initial_fill_level == null
                              ? Colors.red
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                    size: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        SelectFillPercentage(finalFill: true, bin: widget.bin),
                    fullscreenDialog: true));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FINAL FILL LEVEL',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.bin.final_fill_level == null
                            ? 'NOT SET'
                            : '${widget.bin.final_fill_level.toString()}%',
                        style: TextStyle(
                          fontSize: 16,
                          color: widget.bin.final_fill_level == null
                              ? Colors.red
                              : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.edit,
                    color: Colors.grey[400],
                    size: 20,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'READY TO HAUL?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      (widget.bin.final_fill_level ?? 0) < 95 ? 'No' : 'Yes',
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
