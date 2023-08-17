import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/services/services.dart';
import '../../main.dart';

class Camera extends StatefulWidget {
  final bool showOverlay;
  final String binID;
  final String imageColumnID;
  final String imagePath;
  const Camera({required this.showOverlay, required this.imagePath, required this.imageColumnID, required this.binID, super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> with AutomaticKeepAliveClientMixin {
  late CameraController controller;
  XFile? imageFile;
  bool _submitting = false;

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.black))));
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future submitImage() async {
    if (imageFile != null) {
      setState(() {
        _submitting = true;
      });
      try {
        final String path = await supabase.storage
            .from(
                '${supabase.auth.currentUser!.userMetadata!['organization_id']}')
            .upload(
              'service_images/${widget.imagePath}.${imageFile!.path.split('.').last}',
              File(imageFile!.path),
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
        final path_to_save = path.split('/').sublist(1).join('/');
        await ServiceApi().setBinImagePath(binID: widget.binID, imagePath: path_to_save, imageColumnID: widget.imageColumnID);
        final url = await supabase.storage
            .from(supabase.auth.currentUser!.userMetadata!['organization_id'])
            .createSignedUrl(path_to_save, 3600);
        setState(() {
          _submitting = false;
        });
        Navigator.of(context).pop(url);
      } catch (e) {
        print(e);
        showInSnackBar('Error: ${e.toString()}');
        setState(() {
          _submitting = false;
        });
      }
    } else {
      showInSnackBar('Error: no image selected.');
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          Positioned.fill(
            child: Column(
              children: [
                widget.showOverlay ? Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.75),
                    child: const Center(
                        child: Text('Align top of bin with outline.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                ) : const SizedBox(),
                !widget.showOverlay ? SizedBox(height: MediaQuery.of(context).size.height * 0.5) : Image(
                  image: const AssetImage('assets/overlay2.png'),
                  width: MediaQuery.of(context).size.width,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(widget.showOverlay ? 0.75 : 0.00),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(65),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(
                            side: BorderSide(width: 4, color: Colors.white)),
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.white.withOpacity(0.25),
                      ),
                      onPressed: () {
                        // Navigator.of(context).pop();
                        onTakePictureButtonPressed();
                        HapticFeedback.heavyImpact();
                      },
                      child: const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          imageFile != null
              ? Positioned(
                  child: _imageConfirmation(),
                )
              : const SizedBox(),
          _submitting
              ? Positioned.fill(
                  child: Container(
                      color: Colors.black.withOpacity(0.75),
                      child: const Center(child: CircularProgressIndicator())))
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _imageConfirmation() {
    return Stack(
      children: [
        Image(
          image: AssetImage(imageFile!.path),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                    ),
                    onPressed: () {
                      setState(() {
                        imageFile = null;
                      });
                    },
                    child: const Text('Retake'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () async {
                      await submitImage();
                    },
                    child: const Text('Use Photo'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
