//**************************************************************
// Encryption/Decryption Service
//**************************************************************
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:memory_enhancer_app/services/text_to_speech/IamOptions.dart';
import 'package:soundpool/soundpool.dart';
import 'package:stacked/stacked.dart';

@singleton
class TextToSpeechService with ReactiveServiceMixin {

  String _urlBase = "https://api.us-east.text-to-speech.watson.cloud.ibm.com/instances/8e42e1ca-9f2b-4336-be31-bea6206b1715";
  String _apiKey = "fJB2qReC0uhUEMcMrkkgQuNKWKBKPIB9WeE4IQq0twN7";

  late IamOptions iamOptions;
  late String _accept;
  late String _voice;

  /// Initialization function called when the app is first opened
  Future<void> initialize() async {
    this.iamOptions = await IamOptions(
        iamApiKey: _apiKey,
        url: _urlBase).build();
    this._accept = "audio/mp3";
    this._voice = "en-US_AllisonV3Voice";
  }

  void setVoice(String v) {
    this._voice = v;
  }

  String _getUrl(method, {param = ""}) {
    String url = iamOptions.url;
    if (iamOptions.url == "") {
      url = _urlBase;
    }
    return "$url/v1/$method$param";
  }


  Future<void> playText(String text) async {
    // Synthesize text
    Uint8List synthesizedText = await _toSpeech(text);

    // Play synthesize text
    Soundpool sp = Soundpool.fromOptions();
    sp.loadAndPlayUint8List(synthesizedText);
  }

  Future<Uint8List> _toSpeech(String text) async {
    String token = this.iamOptions.accessToken;
    var response = await http.post(
      Uri.parse(_getUrl("synthesize", param: "?voice=$_voice")),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        HttpHeaders.contentTypeHeader: "application/json",
        'Accept': this._accept
      },
      body: '{\"text\":\"$text\"}',
    );
    return response.bodyBytes;
  }


}
