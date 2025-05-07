import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionService {
  static Future<List<String>> scanForAllergies({
    required String filePath,
    required List<String> selectedAllergies,
    required TextRecognizer recognizer,
  }) async {
    final inputImage = InputImage.fromFilePath(filePath);
    final recognizedText = await recognizer.processImage(inputImage);
    final text = recognizedText.text.toLowerCase();

    return selectedAllergies
        .where((allergy) => text.contains(allergy.toLowerCase()))
        .toList();
  }
}
