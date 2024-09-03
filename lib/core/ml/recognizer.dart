import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../../data/datasource/auth_local_datasource.dart';
import 'recognition_embedding.dart';

/// A class responsible for face recognition using a TensorFlow Lite model.
///
/// This class handles loading the model, processing images, and performing
/// face recognition tasks.
class Recognizer {
  /// The TensorFlow Lite interpreter used for running the model.
  late Interpreter interpreter;

  /// Options for configuring the interpreter.
  late InterpreterOptions _interpreterOptions;

  /// The width of the input image required by the model.
  static const int WIDTH = 112;

  /// The height of the input image required by the model.
  static const int HEIGHT = 112;

  /// The path to the TensorFlow Lite model file.
  String get modelName => 'assets/mobile_face_net.tflite';

  /// Loads the TensorFlow Lite model from assets.
  ///
  /// This method initializes the interpreter with the model file.
  /// If loading fails, an error message is printed to the console.
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(modelName);
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  /// Creates a new instance of the Recognizer.
  ///
 /// * [numThreads] specifies the number of threads to use for inference.
  Recognizer({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }
    loadModel();
  }

  /// Converts an image to a normalized float array suitable for model input.
  ///
  /// *[inputImage] is the image to be processed.
  /// Returns a List<dynamic> representing the processed image data.
  
  List<dynamic> imageToArray(img.Image inputImage) {
    img.Image resizedImage =
        img.copyResize(inputImage, width: WIDTH, height: HEIGHT);
    List<double> flattenedList = resizedImage.data!
        .expand((channel) => [channel.r, channel.g, channel.b])
        .map((value) => value.toDouble())
        .toList();
    Float32List float32Array = Float32List.fromList(flattenedList);
    int channels = 3;
    int height = HEIGHT;
    int width = WIDTH;
    Float32List reshapedArray = Float32List(1 * height * width * channels);
    for (int c = 0; c < channels; c++) {
      for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
          int index = c * height * width + h * width + w;
          reshapedArray[index] =
              (float32Array[c * height * width + h * width + w] - 127.5) /
                  127.5;
        }
      }
    }
    return reshapedArray.reshape([1, 112, 112, 3]);
  }

  /// Performs face recognition on a given image.
  ///
  ///* [image] is the input image to process.
  ///* [location] is the rectangle defining the face location in the image.
  /// Returns a RecognitionEmbedding containing the face location and embedding.
  RecognitionEmbedding recognize(img.Image image, Rect location) {
    //TODO crop face from image resize it and convert it to float array
    var input = imageToArray(image);
    print(input.shape.toString());

    //TODO output array
    List output = List.filled(1 * 192, 0).reshape([1, 192]);

    //TODO performs inference
    final runs = DateTime.now().millisecondsSinceEpoch;
    interpreter.run(input, output);
    // final run = DateTime.now().millisecondsSinceEpoch - runs;
    // print('Time to run inference: $run ms$output');

    //TODO convert dynamic list to double list
    List<double> outputArray = output.first.cast<double>();

    return RecognitionEmbedding(location, outputArray);
  }

  /// Finds the nearest matching face embedding.
  ///
  ///* [emb] is the embedding to compare.
  ///* [authFaceEmbedding] is the authenticated face embedding to compare against.
  /// Returns a PairEmbedding containing the distance between the embeddings.
  PairEmbedding findNearest(List<double> emb, List<double> authFaceEmbedding) {
    PairEmbedding pair = PairEmbedding(-5);

    double distance = 0;
    for (int i = 0; i < emb.length; i++) {
      double diff = emb[i] - authFaceEmbedding[i];
      distance += diff * diff;
    }
    distance = sqrt(distance);
    if (pair.distance == -5 || distance < pair.distance) {
      pair.distance = distance;
    }
    //}
    return pair;
  }

  /// Validates if a given face embedding matches the authenticated user.
  ///
  ///* [emb] is the embedding to validate.
  /// Returns a Future<bool> indicating whether the face is valid (true) or not (false).
  Future<bool> isValidFace(List<double> emb) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final faceEmbedding = authData!.user!.faceEmbedding;
    PairEmbedding pair = findNearest(
        emb,
        faceEmbedding!
            .split(',')
            .map((e) => double.parse(e))
            .toList()
            .cast<double>());
    print("distance= ${pair.distance}");
    if (pair.distance < 1.0) {
      return true;
    }
    return false;
  }
}

class PairEmbedding {
  double distance;
  PairEmbedding(this.distance);
}
