import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:memory_enhancer_app/custom_fonts/my_flutter_app_icons.dart';
import 'package:memory_enhancer_app/file_operations.dart';

/// Memory Enhancer App Code

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  /*
  final Map<String, HighlightedWord> _highlights = {
    'Shawn': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Team Amazing': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'Amazing': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };
  */

  // Instantiate an instance of speech-to-text class
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false; // isListening initially set to false.

  /// The placeholder text for transcribed text.
  String _text = 'Press the microphone button and start speaking';

  /// The confidence level for speech to text api
  double _confidence = 1.0;

  /// Instantiate an instance of FileOperations class
  FileOperations fileOperations = new FileOperations();

  String _triggers = 'So you are saying';

  Future<void> _getTriggers() async {
    String result = await fileOperations.readData('triggers');
    setState(() {
      _triggers = result;
    });
  }

  // Records note to file if trigger word is said.
  // Trying to figur out why this isn't working.
  // Maybe someone can look at it and see where I'm going wrong.
  void _recordNotes(String content) {
    var _triggerList = _triggers.split('\n'); // Makes array of trigger words.
    print(_triggerList); // temporary so I can see if my array is populated
    var exist = false; // boolean to see if word is in triggerList array
    // Checks to see if word is in triggerList array.
    for (var word in _triggerList) {
      if (content.contains(word)) {
        exist = true;
        break;
      }
    }
    // If word is present in array, then write content to file.
    // If word is not present, then print content was not saved.
    if (exist) {
      fileOperations.writeData('notes', 'content');
    } else {
      print('Did not save to file.');
    }

    /* this code works, but only if I hardcode the word in
    **
    if (content.contains('dinner')) {
      fileOperations.writeData(content);
    } else {
      print('Did not save to file.');
    }*/
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _getTriggers();
    fileOperations.writeData('triggers', 'dinner'); // temporary
  }

  // Bottom navigation controls.
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 45,
        selectedItemColor: Colors.red[800],
        selectedFontSize: 16.0,
        unselectedFontSize: 16.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'HOME',
          ), // Home
          BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.doc_text),
            label: 'NOTES',
          ), // Notes
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'SETTINGS'), // Settings
          BottomNavigationBarItem(
              icon: Icon(Icons.help_outlined), label: 'HELP') // Help
        ],
        currentIndex: _selectedIndex,
        // Current index number.
        onTap: _onItemTapped,
      ),
    );
  }

  // If speech-to-text is listening, then transcribe text and record to file
  // else speech-to-text is not listening.
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        finalTimeout: Duration(milliseconds: 600000),
        //debugLogging: true,
      );
      if (available) {
        // Changes states of [_isListening] to true to start listening to speaker.
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;

            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      _recordNotes(_text); // Writes note to file.
      // Changes state of [_isListening] to false to stop listening to speaker.
      setState(() => _isListening = false);
      _speech.stop(); // Stops speech-to-text api.
    }
  }
} // End of SpeechScreenState.
