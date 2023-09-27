import 'dart:io';
import 'package:camera/camera.dart';
import 'package:central_driver/views/demo-camera/select_fill_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/services/services.dart';
import 'package:image/image.dart' as img;

import '../../main.dart';

class DemoCamera extends StatefulWidget {
  const DemoCamera({super.key});

  @override
  State<DemoCamera> createState() => _DemoCameraState();
}

class _DemoCameraState extends State<DemoCamera> with AutomaticKeepAliveClientMixin {
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

        final fill_level = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SelectFillLevel(),
            fullscreenDialog: true,
          ),
        );

        if (fill_level != null) {
          final String fileName = '${fill_level}_PERCENT_${DateTime.now().toString()}';
          await supabase.storage
              .from(
              'analyzer_images')
              .upload(
            fileName,
            File(imageFile!.path),
            fileOptions:
            const FileOptions(cacheControl: '3600', upsert: true),
          );
          final imageBytes = await imageFile!.readAsBytes();
          final watermarkedImgBytes = await ImageWatermark.addTextWatermark(
            imgBytes: imageBytes,             ///image bytes
            watermarkText: DateTime.now().toString(),      ///watermark text
            dstX: 50,                   ///position of watermark x coordinate
            dstY: 50,                   ///y coordinate
            color: Colors.white, ///default : Colors.black
          );
          // Get temporary directory
          final Directory tempDir = await getTemporaryDirectory();

          // Use provided filename or generate one
          final File tempFile = File('${tempDir.path}/$fileName.jpg');

          // Write bytes to the file
          await tempFile.writeAsBytes(watermarkedImgBytes);

          await GallerySaver.saveImage(tempFile.path);
          setState(() {
            _submitting = false;
            imageFile = null;
          });
          showInSnackBar('Image saved to camera roll!');
        } else {
          setState(() {
            _submitting = false;
          });
        }

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
                AppBar(
                  title: const Text('Central', style: TextStyle(fontWeight: FontWeight.w800)),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                            title: const Text('Ready to logout?'),
                            actions: <Widget>[
                              PlatformDialogAction(
                                  child: PlatformText('Cancel'),
                                  onPressed: () => Navigator.pop(context)),
                              PlatformDialogAction(
                                child: PlatformText('Logout',
                                    style: const TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await supabase.auth.signOut();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                  backgroundColor: Colors.black.withOpacity(0.75),
                  elevation: 0,
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.75),
                    child: const Center(
                        child: Text('Align top of bin with outline.',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600))),
                  ),
                ),
                Image(
                  image: const AssetImage('assets/overlay2.png'),
                  width: MediaQuery.of(context).size.width,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black.withOpacity(0.75),
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
        Positioned.fill(
          child: Image(
            image: AssetImage(imageFile!.path),
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 50),
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
