//**************************************************************
// Speech Service
// Author: Christian Ahmed
//**************************************************************
import 'package:injectable/injectable.dart';
import 'package:porcupine/porcupine.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';

@singleton
class SpeechService with ReactiveServiceMixin {
  bool speechAvailable = false;
  stt.SpeechToText speech = stt.SpeechToText();
  PorcupineManager? porcupineManager;

  Function(SpeechRecognitionResult result)? contextCallback;

  /// Initialization function called when the app is first opened
  Future<void> initializeSpeechService() async {
    await createPorcupineManager();

    speechAvailable = await speech.initialize(
      onStatus: (status) async {
        print('Speech-to-text status: ' + status);

        // Need to restart PorcupineManager if there is no detection
        if (speech.isNotListening) {
          await listenForWakeWord();
        }
      },
      onError: (errorNotification) {
        print('Speech to text error: ' + errorNotification.errorMsg);
      },
    );

    setWakelock(true);
    listenForWakeWord();
  }

  void setContextCallback(Function(SpeechRecognitionResult result) callback) {
    contextCallback = callback;
    notifyListeners();
  }

  /// Start listening for user input
  /// resultCallback is optionally specified by the caller
  Future<void> startListening({Function(SpeechRecognitionResult result)? resultCallback}) async {
    if (speechAvailable) {
      await porcupineManager?.stop();
      await speech.listen(
          partialResults: true,
          onResult: (result) async {
            print('Speech to text result: ' + result.recognizedWords);
            if (resultCallback != null) resultCallback(result); // Specified from caller
            if (contextCallback != null) contextCallback!(result); // Set in SpeechService
            await listenForWakeWord();
            notifyListeners();
          },
          cancelOnError: true);
      notifyListeners();
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  /// Stop listening to user input and free up the audio stream
  Future<void> stopListening() async {
    await speech.stop();
  }

  // Create an instance of your porcupineManager which will listen for the given wake words
  // Must call start on the manager to actually start listening
  Future<void> createPorcupineManager() async {
    try {
      porcupineManager = await PorcupineManager.fromKeywords(
          Porcupine.BUILT_IN_KEYWORDS, wakeWordCallback);
    } on PvError catch (err) {
      // handle porcupine init error
      print('Porcupine error: ' + (err.message ?? 'None'));
    }
  }

  // The function that's triggered when the Porcupine instance recognizes a wake word
  // Input is the index of the wake word in the list of those being used
  Future<void> wakeWordCallback(int word) async {
    print('Wake word index : ' + word.toString());

    // Terminator - resets audio resources
    if (word == 13) {
      await disposeResources();
      await createPorcupineManager();
      await listenForWakeWord();
    } else {
      await startListening();
    }
  }

  // Begin listening for a wake word
  Future<void> listenForWakeWord() async {
    try {
      await porcupineManager?.start();
    } on PvAudioException catch (ex) {
      // deal with either audio exception
      print('PvAudioException: ' + (ex.message ?? 'None'));
    }
  }

  // Stop listening for a wake word
  Future<void> stopListeningForWakeWord() async {
    print('Stopping wake word listener');
    await porcupineManager?.stop();
  }

  // Dispose all the resources
  Future<void> disposeResources() async {
    print('Disposing speech resources');
    porcupineManager?.delete();
    await speech.cancel();
    await speech.stop();
  }

  // Keep the screen on while the voice recognition screen is open
  void setWakelock(bool val) {
    val ? Wakelock.enable() : Wakelock.disable();
  }
}
