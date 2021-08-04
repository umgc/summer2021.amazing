/*
 * Microphone Streamer
 * Author: Christian Ahmed
 */

import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';

const int tSampleRate = 44000;

class MicrophoneStreamer {
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInitiated = false;
  StreamSubscription? _mRecordingDataSubscription;

  late Sink sttSink;

  void initialize() {
    _startRecorder();
  }

  Future<void> _startRecorder() async {
    await _mRecorder!.openAudioSession();
    _mRecorderIsInitiated = true;
  }

  Future<void> setSttSink(Sink sink) async {
    this.sttSink = sink;
  }

  // Here is the code to record microphone sound to a Stream
  Future<void> startListening({required sttSink}) async {
    if(_mRecorderIsInitiated) {
      _listen(sttSink: sttSink);
    }
    else {
      _startRecorder().then((value) => _listen(sttSink: sttSink));
    }
  }

  // Here is the code to record microphone sound to a Stream
  Future<void> _listen({required sttSink}) async {
    assert(_mRecorderIsInitiated);
    var recordingDataController = StreamController<Food>();
    _mRecordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            sttSink.add(buffer.data!);
          }
        });

    await _mRecorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
  }

  // Here is the code to stop recording microphone sound to a Stream
  Future<void> stopListening() async {
    await _mRecorder!.stopRecorder();
    if (_mRecordingDataSubscription != null) {
      await _mRecordingDataSubscription!.cancel();
      _mRecordingDataSubscription = null;
    }
  }

  // Here is the code to dispose of all the resources
  void dispose() {
    stopListening();
    _mRecorder!.closeAudioSession();
    _mRecorder = null;
  }

}
