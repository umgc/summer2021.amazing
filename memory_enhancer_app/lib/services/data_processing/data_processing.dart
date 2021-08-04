//**************************************************************
// Data Processing Service
// Author: Christian Ahmed
//**************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_enhancer_app/services/file_operations/file_operations.dart';
import 'package:memory_enhancer_app/notes.dart';
import 'package:memory_enhancer_app/services/data_processing/aho_corasick_search/aho_corasick.dart';
import 'package:memory_enhancer_app/services/data_processing/aho_corasick_search/match.dart';
import 'package:memory_enhancer_app/services/speech/custom/speech_to_text_service.dart';
import 'package:memory_enhancer_app/services/speech/custom/text_to_speech_service.dart';
import 'package:stacked/stacked.dart';


@singleton
class DataProcessingService with ReactiveServiceMixin {

  // Index of the matching start-recording trigger.
  // It is the index of the last character of the start trigger word / phrase
  int _startTriggerIndex = -1;

  // Index of the matching stop-recording trigger
  // It is the index of the first character of the stop trigger word / phrase
  int _stopTriggerIndex = -1;

  // Index of the matching replay information trigger
  // It is the index of the last character of the stop trigger word / phrase
  int _replayTriggerIndex = -1;

  // User transcription
  String _userTranscription = "";

  // Start recording triggers
  List<String> _startRecordingTriggers = [];

  // Stop recording triggers
  List<String> _stopRecordingTriggers = [];

  // Replay triggers
  List<String> _replayTriggers = [];

  // All triggers
  List<String> _allTriggers = [];

  // User's notes stored on the device
  List<String> _userNotes = [];

  // Words to ignore in the note searches
  List<String> _ignoredWords = [];

  // User's words to save as a note
  String _userWordsToSave = "";

  String _stopListeningPhrase = "thank you amazing";


  // ---------------------------------------------------------------------------
  // Initialization of the service
  // ---------------------------------------------------------------------------
  Future<void> initialize() async {
    // Initialize the Triggers and User Notes
    refresh();
    _initializeIgnoredWords();
  }


  // ---------------------------------------------------------------------------
  // Initialization of the service
  // ---------------------------------------------------------------------------
  Future<void> processSpeechTranscriptions(List<String> transcriptions) async {
    _reset();

    // If transcriptions is empty, it means that the speech transcription was not successfully processed.
    if(transcriptions.isEmpty) {
      voiceMessage("Sorry! I could not successfully transcribe your conversation.");
      return;
    }

    // Identify the user's transcriptions among all the transcriptions
    _extractUserTranscription(transcriptions);

    // If transcriptions is empty, it means that the speech transcription was not successfully processed.
    if(_userTranscription.isEmpty){
      print("DATA PROCESSING / Could not identify user transcription");
    }

    // Handle note recording scenario
    bool isRecordScenario = _handleRecordScenario();

    // Handle note replay scenario
    if(!isRecordScenario) {
      _handleReplayScenario();
    }

    // If signal to stop listening, stop listening
    if(_userTranscription.contains(_stopListeningPhrase)) {
      GetIt.I.get<SpeechToTextService>().processSpeechRecognize();
    }
  }


  // ---------------------------------------------------------------------------
  // Handle scenario where the user is requesting a note recording
  // ---------------------------------------------------------------------------
  bool _handleRecordScenario() {
    // Match a start recording trigger
    _startTriggerIndex = _identifyTrigger(_startRecordingTriggers, true);

    // If no start trigger matched, stop scenario handling
    if(_startTriggerIndex == -1) {
      print("DATA PROCESSING / No start recording trigger identified in user transcription");
      return false;
    }

    // Match a stop recording trigger
    _stopTriggerIndex = _identifyTrigger(_stopRecordingTriggers);

    // If no stop trigger matched, set the stop trigger index to the last
    // character of the user transcription
    if(_stopTriggerIndex == -1) {
      print("DATA PROCESSING / No end recording trigger identified in user transcription");
      _stopTriggerIndex = _userTranscription.length;
    }

    // Get notes between the indexes of the start and stop triggers
    _userWordsToSave = _userTranscription.substring(_startTriggerIndex, _stopTriggerIndex);

    // trim the spaces at the start and end of the notes
    _userWordsToSave = _userWordsToSave.trim();
    print("DATA PROCESSING / User note to record : [$_userWordsToSave]");

    // Save the notes
    if(_userWordsToSave.isNotEmpty) {
      if(_userWordsToSave.startsWith("my")) {
        _userWordsToSave = _userWordsToSave.replaceFirst("my", "your");
      }
      print("DATA PROCESSING / Saving user note : [$_userWordsToSave]");
      saveNote(_userWordsToSave);
      voiceMessage("I save that for you");
    }

    return true;
  }


  // ---------------------------------------------------------------------------
  // Search for trigger in the user transcription
  // ---------------------------------------------------------------------------
  int _identifyTrigger(List<String> triggers, [bool includeTriggerLength = false]) {
    int matchIndex = -1;

    for(int i = 0; i < triggers.length; i++) {
      String trigger = triggers[i];
      matchIndex = _userTranscription.indexOf(trigger);
      // if a trigger found
      if(matchIndex > -1) {
        print("DATA PROCESSING / Trigger found : [$trigger] at index $matchIndex");
        // Set the index to the last character of the trigger phrase/word
        // For note recording, start recording at the end of the trigger
        if (includeTriggerLength) {
          matchIndex += trigger.length;
        }
        break;
      }
    }

    return matchIndex;
  }


  // ---------------------------------------------------------------------------
  // Handle scenario where the user is requesting a note replay
  // ---------------------------------------------------------------------------
  bool _handleReplayScenario() {
    // Match a start recording trigger
    _replayTriggerIndex = _identifyTrigger(_replayTriggers, true);

    // If no start trigger matched, stop scenario handling
    if(_replayTriggerIndex == -1) {
      print("DATA PROCESSING / No replay trigger identified in user transcription");
      return false;
    }

    // Get user words after the indexes of the replay
    String userInput = _userTranscription.substring(_replayTriggerIndex, _userTranscription.length);

    // Play note if found
    if(userInput.isEmpty) {
      voiceMessage("Sorry! I did not understand your request for assistance.");
      return false;
    }

    // trim the spaces at the start and end of the notes
    userInput = userInput.trim();
    print("DATA PROCESSING / Recall user input : $userInput");

    // Search for user notes matching the user words
    String matchedNoted = _retrieveMatchingUserNote(userInput);

    // Play note if found
    if(matchedNoted.isNotEmpty) {
      voiceMessage(matchedNoted);
    } else {
      voiceMessage("Sorry! I could not find any note matching you request for assistance.");
      return false;
    }

    return true;
  }


  // ---------------------------------------------------------------------------
  // Identify the user transcriptions
  // ---------------------------------------------------------------------------
  void _extractUserTranscription(List<String> transcriptions) {
    // Initialize the variable
    _userTranscription = "";

    // If only one transcription, it will be only the user transcription
    if(transcriptions.length == 1) {
      _userTranscription = transcriptions.first;
    }
    else if(transcriptions.length > 1) {
      // Identify the transcriptions that matches the most trigger word
      _userTranscription = _identifyHighestMatchTranscription(transcriptions);
    }

    print("DATA PROCESSING / User Transcription : $_userTranscription");
  }


  // ---------------------------------------------------------------------------
  // Save note
  // ---------------------------------------------------------------------------
  Future<void> saveNote(String noteToSave) async {
    // Create new note with 
    Note note = Note('', DateTime.now(), noteToSave);
    print("DATA PROCESSING / Saving notes : $noteToSave");
    GetIt.I.get<FileOperations>().writeNoteToFile(note).whenComplete(() =>
      initializeUserNotes
    );
  }


  // ---------------------------------------------------------------------------
  // Search for matching note
  // Using the Aho-Corasick algorithm to match as many words in a note
  // ---------------------------------------------------------------------------
  String _retrieveMatchingUserNote(String userInput) {
    // Split user input in list of words for the search
    List<String> tempInputWords = userInput.split(" ");
    List<String> userInputWords = [];

    // Remove single character to avoid quadratic time complexity
    for(int i  = 0; i < tempInputWords.length; i++) {
      if(tempInputWords[i].length > 1 && !_ignoredWords.contains(tempInputWords[i])) {
        userInputWords.add(tempInputWords[i].toLowerCase());
      }
    }
    print("DATA PROCESSING / Recall user words : $userInputWords");
    final ahoCorasick = AhoCorasick.fromWordList(userInputWords);

    String highestMatchedNote = "";
    int highestMatchedWordsCount = 0;
    List<Match> matches;

    // Iterate through the user's notes and find the one that matches the highest
    // number of words uttered by the user.
    for(int i = 0; i < _userNotes.length; i++) {
      // get a user note
      String note = _userNotes[i];

      // get matches between user's uttered words and the user's note
      matches = ahoCorasick.matches(note);

      // if matches not found, continue iterating
      if(matches.isEmpty) {
        continue;
      }

      // Some matches found
      // if current matched exceed previous one in matched words, set it as the new match
      if(matches.length > highestMatchedWordsCount) {
        highestMatchedWordsCount = matches.length;
        highestMatchedNote = note;
        print("DATA PROCESSING / New higher recall match : $highestMatchedNote");
      }
    }

    print("DATA PROCESSING / Final recall match : $highestMatchedNote");
    return highestMatchedNote;
  }


  // ---------------------------------------------------------------------------
  // Identify the transcriptions with highest match of trigger words
  // ---------------------------------------------------------------------------
  String _identifyHighestMatchTranscription(List<String> transcriptions) {
    final ahoCorasick = AhoCorasick.fromWordList(_allTriggers);

    String highestMatchedTranscription = "";
    int highestMatchedTriggersCount = 0;
    List<Match> matches;

    // Iterate through the transcriptions and find the one that matches the
    // highest number of trigger words.
    for(int i = 0; i < transcriptions.length; i++) {
      String transcription = transcriptions[i];
      matches = ahoCorasick.matches(transcription);

      // if matches not found, continue iterating
      if(matches.isEmpty) {
        continue;
      }

      // Some matches found
      // if current matched exceed previous one in matched words, set it as the new match
      if(matches.length > highestMatchedTriggersCount) {
        highestMatchedTriggersCount = matches.length;
        highestMatchedTranscription = transcription;
      }
    }

    print("DATA PROCESSING / User transcription : $highestMatchedTranscription");
    return highestMatchedTranscription;
  }


  // ---------------------------------------------------------------------------
  // Synthesize message to voice and play voice.
  // ---------------------------------------------------------------------------
  Future<void> voiceMessage(String message) async {
    print("DATA PROCESSING / Synthesized Message : $message");
    GetIt.I.get<TextToSpeechService>().synthesizeText(message);
  }


  // ---------------------------------------------------------------------------
  // Reset values
  // ---------------------------------------------------------------------------
  void _reset() {
    _startTriggerIndex = -1;
    _stopTriggerIndex = -1;
    _replayTriggerIndex = -1;
    _userTranscription = "";
  }


  // ---------------------------------------------------------------------------
  // Refresh triggers and user notes
  // ---------------------------------------------------------------------------
  void refresh() {
    initializeTriggers();
    initializeUserNotes();
  }


  // ---------------------------------------------------------------------------
  // Initialize Triggers
  // ---------------------------------------------------------------------------
  void initializeTriggers() {
    // Start recording triggers
    GetIt.I.get<FileOperations>().readTriggers(0)
        .then((value) => {
          _startRecordingTriggers = value.trimLeft().split("\n")
        })
        .whenComplete(() => _allTriggers.addAll(_startRecordingTriggers))
        .whenComplete(() => print("DATA PROCESSING / Start recording triggers : $_startRecordingTriggers"));


    // Stop recording triggers
    GetIt.I.get<FileOperations>().readTriggers(1)
        .then((value) => {
          _stopRecordingTriggers = value.trimLeft().split("\n")
        })
        .whenComplete(() => _allTriggers.addAll(_stopRecordingTriggers))
        .whenComplete(() => print("DATA PROCESSING / Stop recording triggers : $_stopRecordingTriggers"));


    // Recall triggers
    GetIt.I.get<FileOperations>().readTriggers(2)
        .then((value) => {
          _replayTriggers = value.trimLeft().split("\n")
        })
        .whenComplete(() => _allTriggers.addAll(_replayTriggers))
        .whenComplete(() => print("DATA PROCESSING / Recall triggers : $_replayTriggers")); // TODO : AHMED - comment this line later

  }


  // ---------------------------------------------------------------------------
  // Initialize User's Notes
  // ---------------------------------------------------------------------------
  void initializeUserNotes() {
    // Retrieve all the user's note on the device
    GetIt.I.get<FileOperations>().getNotesData()
        .then((value) => {
          _userNotes = value
        })
        .whenComplete(() => print("DATA PROCESSING / User notes : $_userNotes")); // TODO : AHMED - comment this line later
  }


  // ---------------------------------------------------------------------------
  // Words to ignore in the user's notes search
  // ---------------------------------------------------------------------------
  void _initializeIgnoredWords() {
    _ignoredWords = ["i", "you", "he", "she", "we", "they", "my", "your", "am", "is", "are", "the", "a", "it" "it's", "i'm"];
  }

}