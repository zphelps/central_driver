import 'package:central_driver/main.dart';
import 'package:central_driver/state/services.dart';
import 'package:central_driver/views/service-bin-flow/service-bin-flow.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';
import '../camera/camera.dart';

class InitialFillLevel extends StatefulWidget {
  final String serviceID;
  final Bin bin;

  const InitialFillLevel(
      {required this.serviceID, required this.bin, super.key});

  @override
  State<InitialFillLevel> createState() => _InitialFillLevelState();
}

class _InitialFillLevelState extends State<InitialFillLevel> {
  bool _loading = false;
  bool _nextEnabled = false;
  String? signedURL;

  void updateNextEnabled() {
    setState(() {
      _nextEnabled = widget.bin.initial_fill_image != null;
    });
  }

  Future _getSignedURL(String path) async {
    final url = await supabase.storage.from(supabase.auth.currentUser!.userMetadata!['organization_id']).createSignedUrl(path, 3600);
    setState(() {
      signedURL = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateNextEnabled();
    if (signedURL == null && widget.bin.initial_fill_image != null) {
      _getSignedURL(widget.bin.initial_fill_image!);
    }
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
                .update((profile) => profile.copyWith(step: 2));
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Initial Fill Level',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Take a photo of the top of the bin to record the initial fill level.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 65),
                        child: signedURL != null ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Image.network(
                                  signedURL!,
                                  fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Positioned(child: IconButton(icon: const Icon(Icons.restart_alt, color: Colors.white, size: 50), onPressed: () async {
                                final url = await Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => Camera(
                                        showOverlay: true,
                                        binID: widget.bin.id,
                                        imageColumnID: 'initial_fill_image',
                                        imagePath:
                                        'compaction_images/before/${widget.bin.id}'),
                                    fullscreenDialog: true));
                                setState(() {
                                  signedURL = url;
                                });
                              },))
                            ],
                          ),
                        ) : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: const BorderSide(width: 0, color: Colors.transparent),
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.grey[200],
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              final url = await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Camera(
                                      showOverlay: true,
                                      binID: widget.bin.id,
                                      imageColumnID: 'initial_fill_image',
                                      imagePath:
                                      'compaction_images/before/${widget.bin.id}'),
                                  fullscreenDialog: true));
                              setState(() {
                                signedURL = url;
                              });
                            },
                            child: widget.bin.initial_fill_image != null ? const CircularProgressIndicator() : const Column(
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
                                    color: Colors.grey
                                  ),
                                ),
                              ],
                            )),
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
                        await BinsApi().updateStep(widget.bin.id, 4);
                        context
                            .flow<ServiceBinFlowState>()
                            .update((profile) => profile.copyWith(step: 4));
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
