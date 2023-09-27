import 'package:central_driver/views/camera/camera.dart';
import 'package:central_driver/views/service-bin-flow/service-bin-flow.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../api/bins/bins.dart';
import '../../api/services/services.dart';
import '../../types/bin.dart';
import '../../types/service_report.dart';

class BinPhotos extends StatefulWidget {
  final Bin bin;

  const BinPhotos(
      {required this.bin, super.key});

  @override
  State<BinPhotos> createState() => _BinPhotosState();
}

class _BinPhotosState extends State<BinPhotos> {
  bool _loading = false;
  bool _nextEnabled = false;

  void _updateNextEnabled() {
    setState(() {
      _nextEnabled = widget.bin.left_image != null &&
          widget.bin.right_image != null &&
          widget.bin.front_image != null &&
          widget.bin.back_image != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateNextEnabled();
  }

  @override
  Widget build(BuildContext context) {
    _updateNextEnabled();
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
                .update((profile) => profile.copyWith(step: 0));
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
                      'Collect Photos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Take photos of the bin from different angles.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.bin.left_image != null ? Colors.grey[200] : const Color(0xffD9D9D9),
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Camera(
                                      showOverlay: false,
                                      binID: widget.bin.id,
                                      imageColumnID: 'left_image',
                                      imagePath:
                                          'before_images/${widget.bin.id}_left_image'),
                                  fullscreenDialog: true));
                              _updateNextEnabled();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.bin.left_image != null ? Icons.check_circle : Icons.camera_alt,
                                  color: widget.bin.left_image != null ? Colors.green : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                Text('Left',
                                    style: TextStyle(
                                      color: widget.bin.left_image != null ? Colors.grey : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: widget.bin.left_image != null ? TextDecoration.lineThrough : null,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.bin.back_image != null ? Colors.grey[200] : const Color(0xffD9D9D9),
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Camera(
                                      showOverlay: false,
                                      binID: widget.bin.id,
                                      imageColumnID: 'back_image',
                                      imagePath:
                                      'before_images/${widget.bin.id}_back_image'),
                                  fullscreenDialog: true));
                              _updateNextEnabled();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.bin.back_image != null ? Icons.check_circle : Icons.camera_alt,
                                  color: widget.bin.back_image != null ? Colors.green : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                Text('Back',
                                    style: TextStyle(
                                      color: widget.bin.back_image != null ? Colors.grey : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: widget.bin.back_image != null ? TextDecoration.lineThrough : null,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Image(
                      image: AssetImage('assets/container-w-lines.png'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.bin.front_image != null ? Colors.grey[200] : const Color(0xffD9D9D9),
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Camera(
                                      showOverlay: false,
                                      binID: widget.bin.id,
                                      imageColumnID: 'front_image',
                                      imagePath:
                                      'before_images/${widget.bin.id}_front_image'),
                                  fullscreenDialog: true));
                              _updateNextEnabled();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.bin.front_image != null ? Icons.check_circle : Icons.camera_alt,
                                  color: widget.bin.front_image != null ? Colors.green : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                Text('Front',
                                    style: TextStyle(
                                      color: widget.bin.front_image != null ? Colors.grey : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: widget.bin.front_image != null ? TextDecoration.lineThrough : null,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.bin.right_image != null ? Colors.grey[200] : const Color(0xffD9D9D9),
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.all(16),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => Camera(
                                    showOverlay: false,
                                      binID: widget.bin.id,
                                      imageColumnID: 'right_image',
                                      imagePath:
                                      'before_images/${widget.bin.id}_right_image'),
                                  fullscreenDialog: true));
                              _updateNextEnabled();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  widget.bin.right_image != null ? Icons.check_circle : Icons.camera_alt,
                                  color: widget.bin.right_image != null ? Colors.green : Colors.black,
                                ),
                                const SizedBox(width: 10),
                                Text('Right',
                                    style: TextStyle(
                                      color: widget.bin.right_image != null ? Colors.grey : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      decoration: widget.bin.right_image != null ? TextDecoration.lineThrough : null,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
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
                        await BinsApi().updateStep(widget.bin.id, 2);
                        context
                            .flow<ServiceBinFlowState>()
                            .update((profile) => profile.copyWith(step: 2));
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
