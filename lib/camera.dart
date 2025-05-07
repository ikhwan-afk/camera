import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:appcamera/camera_controls.dart';
import 'package:appcamera/scan_overlay.dart';
import 'package:appcamera/text_recognition_service.dart';
import '../result_page.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final List<String> selectedAllergies;

  const CameraScreen({
    super.key,
    required this.cameras,
    required this.selectedAllergies,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late TextRecognizer textRecognizer;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> scanImage(XFile file) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      final detected = await TextRecognitionService.scanForAllergies(
        filePath: file.path,
        selectedAllergies: widget.selectedAllergies,
        recognizer: textRecognizer,
      );
      navigateToResultScreen(detectedAllergies: detected);
    } catch (e) {
      debugPrint("Error during scan: $e");
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Future<void> takePicture() async {
    if (!controller.value.isInitialized || isProcessing) return;
    final XFile file = await controller.takePicture();
    scanImage(file);
  }

  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) scanImage(pickedFile);
  }

  void navigateToResultScreen({required List<String> detectedAllergies}) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (_, __, ___) => ResultScreen(detectedAllergies: detectedAllergies),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized)
      return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          const ScanOverlay(),
          CameraControls(
            isProcessing: isProcessing,
            onCapture: takePicture,
            onPickImage: pickImageFromGallery,
            onClose: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
