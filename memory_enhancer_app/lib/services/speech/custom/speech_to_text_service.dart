// Author: Christian Ahmed

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:memory_enhancer_app/services/data_processing/data_processing.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';
import 'package:web_socket_channel/io.dart';
import 'package:xml/xml.dart';
import 'dart:async';

import 'IamOptions.dart';
import 'microphone_streamer.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';

@singleton
class SpeechToTextService with ReactiveServiceMixin {

  // The WebSocket channel to connect to IBM cloud speech to text service
  late IOWebSocketChannel channel;

  late String _webSocketUrlBase;
  late String _apiKey;
  late String token;
  late IamOptions iamOptions;

  static const String _modelId = "en-US_BroadbandModel";
  static const String _contentType = "audio/l16;rate=$_RATE;channels=$_CHANNELS";
  static const bool _speaker_Labels = true;
  static const int _CHANNELS = 1; // Recording channel. Should be one : the microphone.
  static const int _RATE = 44100; // Standard audio rate
  String _serviceStartMessage = "";

  bool isListening = false;

  // The microphone Streamer
  late MicrophoneStreamer _micStreamer;

  var _finalTranscriptions = [];
  var _speakerLabels = [];
  var _simplifiedSpeakerLabels = [];
  String _fullTranscription = "";
  String interimTranscription = "";
  String _interimFinalTranscription = "";
  HashMap<int, String> _distinctSpeakerTexts = new HashMap<int, String>();
  LinkedHashMap? _lastResponseJson;

  // Porcupine
  PorcupineManager? _porcupineManager;

  Future<void> loadCredentials() async {
    String xmlBody = await rootBundle.loadString('assets/ibm_watson/speech_to_text_credentials.xml');
    XmlDocument xml = XmlDocument.parse(xmlBody);
    _webSocketUrlBase = xml.getElement("credentials")!.getElement("serviceUrl")!.text;
    _apiKey = xml.getElement("credentials")!.getElement("apiKey")!.text;
  }

  void initializeServiceStartMessage() {
    // Create JSON message to send to the service to enable the listening mode.
    var data = {};
    data["action"] = "start";
    data["content-type"] = _contentType;
    data["continuous"] = true;
    data["interim_results"] = true;
    data["word_confidence"] = true;
    data["inactivity_timeout"] = -1; // no timeout
    data["speaker_labels"] = _speaker_Labels;
    data["end_of_phrase_silence_time"] = 1.0;
    data["split_transcript_at_phrase_end"] = true;
    //data["max_alternatives"] = 3;
    //data["word_alternatives_threshold"] = 0.01;

    _serviceStartMessage = json.encode(data);
  }

  // Initialize the speech-to-text service
  Future<void> initialize() async {
    print("SPEECH-TO-TEXT SERVICE / Initializing service...");

    // Load the service credentials
    await loadCredentials();

    // Initialize connectivity security information
    this.iamOptions = await IamOptions(
        iamApiKey: _apiKey,
        url: _webSocketUrlBase).build();

    // Initialize security token
    token = this.iamOptions.accessToken;

    // Create first JSON message to initiate the service listening mode.
    initializeServiceStartMessage();

    // Instantiate the microphone streamer
    _micStreamer = new MicrophoneStreamer();
    //_micStreamer = new MicrophoneStreamer(sttSink: channel.sink);
    _micStreamer.initialize();

    // Create porcupine manager to listen to wake up word
    await createPorcupineManager();
  }

  // Handle speech recognition
  Future<void> processSpeechRecognize() async {
    if(isListening){
      _listeningModeOff();
      } else {
      _listeningModeOn();
    }
  }


  Future<void> _listeningModeOn() async {
    if(!isListening) {
      await textToSpeechService.synthesizeText("- Memory Enhancer is now listening to you");
      isListening = true;
      notifyListeners();
      startListening();
    }
  }


  Future<void> _listeningModeOff() async {
    if(isListening) {
      isListening = false;
      notifyListeners();
      await stopListening();
      await textToSpeechService.synthesizeText("- Memory Enhancer is no longer listening to you");
      await _processFinalTranscript();
    }
  }

  // Open a new connection with the IBM Speech service
  Future<void> openNewWatsonConnection() async {
    // Create new channel
    channel = IOWebSocketChannel.connect(_getWatsonServiceUrl());

    // Listen to the response from the Watson
    channel.stream.listen((response) {
      // Decode the JSON object
      LinkedHashMap responseJson = json.decoder.convert(response);

      // If the response contains "results", it is a transcription
      if(responseJson.containsKey("results")){
        try {
          // If the response is the final transcription, add it to the final transcriptions array
          if(responseJson["results"][0]["final"]){
            _finalTranscriptions.add(responseJson);
            _lastResponseJson = null;

            String tempValue = responseJson["results"][0]["alternatives"][0]["transcript"].replaceAll("%HESITATION", "");
            _interimFinalTranscription += tempValue + " ";
            GetIt.I.get<DataProcessingService>().processSpeechTranscriptions([tempValue]);

          } else {
            _lastResponseJson = responseJson;
          }

          // Print the returned transcription
          interimTranscription = _interimFinalTranscription + responseJson["results"][0]["alternatives"][0]["transcript"].replaceAll("%HESITATION", "");
          notifyListeners();
          print("---------- $interimTranscription");
        } on Exception catch (ex) {
          // Do nothing
        }
      }

      // If the response contains "speaker_labels", it is a transcription
      if(responseJson.containsKey("speaker_labels")){
        _speakerLabels.add(responseJson);
      }

    }, onError: _onError, onDone: _onDone, cancelOnError: false);
  }

  // Start listening
  Future<void> startListening() async {
    // Clear all data attributes
    clearAttributes();

    // Open a new connection with the IBM Speech service
    await openNewWatsonConnection();

    // Print speech service connectivity status
    if(channel.innerWebSocket == null) {
      print("Current socket ready state UNAVAILABLE...");
    } else {
      print("Current socket ready state : " + channel.innerWebSocket!.readyState.toString());
    }

    // Send the data to activate the listening service
    channel.sink.add(_serviceStartMessage);

    // Enable microphone listening mode
    await _micStreamer.setSttSink(channel.sink);
    await _micStreamer.startListening(sttSink: channel.sink);
  }

  // Stop listening
  Future<void> stopListening() async {
    _micStreamer.stopListening();

    // Send the JSON data to notify the service to stop listening
    var data = {};
    data["action"] = "stop";
    channel.sink.add(json.encode(data));
  }

  // process the final transcription
  Future<void> _processFinalTranscript() async {
    if(_lastResponseJson == null && _finalTranscriptions.isEmpty) {
      return;
    }

    // If there is more response, add them to the final transcriptions
    if(_lastResponseJson != null){
      _finalTranscriptions.add(_lastResponseJson);
    }

    // Concatenate all the transcriptions
    for(var i=0; i < _finalTranscriptions.length; i++){
      _fullTranscription += _finalTranscriptions[i]["results"][0]["alternatives"][0]["transcript"];
      _fullTranscription = _fullTranscription.replaceAll("%HESITATION", "");
    }

    // Separate speakers and their words
    _processSpeakerDiarization();

    print("\n\n\n-----------------------------------------------------------------------------------------------------------\n");
    // Print final transcriptions
    print(_fullTranscription);

    // TODO : Remove later. For testing.
    _distinctSpeakerTexts.forEach((key, value) {
      print("\n-----------------------------------------------------------------------------------------------------------\n");
      print("SPEAKER #$key : $value");
    });
    print("\n-----------------------------------------------------------------------------------------------------------\n\n\n");
  }

  Future<void> _processSpeakerDiarization() async {
    // Simplify speaker labels
    for(var i = 0; i < _speakerLabels.length; i++){
      for(var j = 0; j < _speakerLabels[i]["speaker_labels"].length; j++){
        var label = _speakerLabels[i]["speaker_labels"][j];
        _simplifiedSpeakerLabels.add([label['from'], label['to'], label['speaker']]);
        _distinctSpeakerTexts.putIfAbsent(label['speaker'], () => "");
      }
    }

    // Only one speaker
    if(_speakerLabels.isEmpty) {
      _distinctSpeakerTexts.putIfAbsent(0, () => _fullTranscription);
      return;
    }
    else if(_distinctSpeakerTexts.keys.length == 1) {
      _distinctSpeakerTexts.update(_distinctSpeakerTexts.keys.first, (value) => _fullTranscription);
      return;
    }

    // Assign each transcription word to a speaker
    for(var i = 0; i < _finalTranscriptions.length; i++){
      // Get timestamps for transcript
      var timestamps = _finalTranscriptions[i]["results"][0]["alternatives"][0]["timestamps"];

      // For each timestamp, get the speaker and append word
      for(var j = 0; j < timestamps.length; j++){
        var timestamp = timestamps[j];
        int speaker = _getSpeakerForWord(timestamp[1], timestamp[2]);
        if(speaker >= 0){
          _distinctSpeakerTexts.update(speaker, (value) => value += timestamp[0] + " ");
        }
      }
    }
  }

  // Get the speaker for the word said at timeframe [from-to]; if not found, return -1
  int _getSpeakerForWord(double from, double to) {
    for(var i = 0; i < _simplifiedSpeakerLabels.length; i++){
      if(from == _simplifiedSpeakerLabels[i][0] && to == _simplifiedSpeakerLabels[i][1]){
        return _simplifiedSpeakerLabels[i][2];
      }
    }
    return -1;
  }

  // onError event handler
  Future<void> _onError(Object data, StackTrace trace) async {
    // Print the error
    print(trace.toString());

    // Reopen connection
    openNewWatsonConnection();
  }

  // onDone event handler
  Future<void> _onDone() async {
    //print("Current connection closing... Reopening a new new connection.");
    // Reopen connection since connection now closed.
    openNewWatsonConnection();
  }

  // IBM Watson Speech-to-Text service URL
  Uri _getWatsonServiceUrl(){
    // Parse URL
    return Uri.parse(_getUrl("recognize", param: "?access_token=$token&model=$_modelId"));
  }

  // Build the URL
  String _getUrl(method, {param = ""}) {
    String url = iamOptions.url;
    if (url == "") {
      url = _webSocketUrlBase;
    }
    return "$url/v1/$method$param";
  }

  void dispose() {
    _micStreamer.dispose();
    channel.sink.close();

    clearAttributes();
  }

  // Clear all the attributes
  void clearAttributes() {
    _finalTranscriptions.clear();
    _speakerLabels.clear();
    _simplifiedSpeakerLabels.clear();
    _fullTranscription = "";
    _distinctSpeakerTexts.clear();
    interimTranscription = "";
    _interimFinalTranscription = "";
  }


//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//
// PORCUPINE LOGIC
//
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
// Create an instance of your porcupineManager which will listen for the given wake words
// Must call start on the manager to actually start listening
//----------------------------------------------------------------------------
  Future<void> createPorcupineManager() async {
    try {
      String wakeWordFile = "";
      if (Platform.isAndroid) {
        wakeWordFile = "assets/porcupine/hey_amazing_en_android.ppn";
      } else if (Platform.isIOS) {
        wakeWordFile = "assets/porcupine/hey_amazing_en_ios.ppn";
      }
      _porcupineManager = 
        //await PorcupineManager.fromKeywords(Porcupine.BUILT_IN_KEYWORDS, wakeWordCallback);
      await PorcupineManager.fromKeywordPaths([wakeWordFile],
              (keywordIndex) => _wakeWordCallback(keywordIndex));

      _porcupineManager!.start();
    } on PvError catch (err) {
      // handle porcupine init error
      print('SPEECH-TO-TEXT SERVICE / Porcupine error: ' + (err.message ?? 'None'));
    }
  }


//----------------------------------------------------------------------------
// The function that's triggered when the Porcupine instance recognizes a wake word
// Input is the index of the wake word in the list of those being used
//----------------------------------------------------------------------------
  Future<void> _wakeWordCallback(int keywordIndex) async {
    print('SPEECH-TO-TEXT SERVICE / Wake word index : ' + keywordIndex.toString());

    // Terminator - resets audio resources
    if (keywordIndex == 0) {
      await _listeningModeOn();
    } else {
      await _listeningModeOff();

      // Reset Porcupine manager
      await disposeResources();
      await createPorcupineManager();
      await listenForWakeWord();
    }
  }


  //----------------------------------------------------------------------------
  // // Begin listening for a wake word
  //----------------------------------------------------------------------------
  Future<void> listenForWakeWord() async {
    try {
      await _porcupineManager?.start();
    } on PvAudioException catch (ex) {
      print('SPEECH-TO-TEXT SERVICE / PvAudioException: ' + (ex.message ?? 'None'));
    }
  }


  //----------------------------------------------------------------------------
  // Stop listening for a wake word
  //----------------------------------------------------------------------------
  Future<void> stopListeningForWakeWord() async {
    print('SPEECH-TO-TEXT SERVICE / Stopping wake word listener');
    await _porcupineManager?.stop();
  }


  //----------------------------------------------------------------------------
  // Dispose all the resources
  //----------------------------------------------------------------------------
  Future<void> disposeResources() async {
    print('SPEECH-TO-TEXT SERVICE / Disposing speech-to-text resources');
    _porcupineManager?.delete();
  }


  //----------------------------------------------------------------------------
  // Keep the screen on while the voice recognition screen is open
  //----------------------------------------------------------------------------
  void setWakelock(bool val) {
    val ? Wakelock.enable() : Wakelock.disable();
  }


}
