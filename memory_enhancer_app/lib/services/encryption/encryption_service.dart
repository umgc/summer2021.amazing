//**************************************************************
// Encryption/Decryption Service
// Author: Ayodeji Famudehin
//**************************************************************
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

@singleton
class EncryptionService with ReactiveServiceMixin {
  //final Key key = Key.fromBase16("password");
  final Key _key = Key.fromLength(32);
  final IV _iv = IV.fromLength(16);

  // Cryptor to encrypt and decrypt
  late Encrypter _cryptor;

  EncryptionService() {
    _initializeEncryptionService();
  }

  // Initialization function called when the app is first opened
  Future<void> _initializeEncryptionService() async {
    _cryptor = Encrypter(AES(_key));
  }

  // Encrypts text and return a HEX representation of the encryption.
  String encryptText({required String text}) {
    // Encryption result
    String encrypted = "";

    try {
      Encrypted result = _cryptor.encrypt(text, iv: this._iv);
      print('The encryption has been completed successfully.');
      encrypted = result.base16;
    }
    on Exception catch (e) {
      print('The encryption failed.');
      print(e.toString());
    }

    return encrypted;
  }

  // Decrypts a HEX representation and return a String.
  String decryptText({required String encrypted}) {
    // Decryption result
    String decrypted = "";

    try {
      decrypted = _cryptor.decrypt16(encrypted, iv: this._iv);
      print('The encryption has been completed successfully.');
    }
    on Exception catch (e) {
      print('The encryption failed.');
      print(e.toString());
    }

    return decrypted;
  }

// Encrypts the content file located by the 'filePath'.
  void encryptFile({required filePath}) {
    String encrypted = "";

    try {
      // Read file content
      String fileContent = File(filePath).readAsStringSync();

      // Encrypt content
      encrypted = this.encryptText(text: fileContent);

      // If encryption successful, update the file with the encrypted text
      if(encrypted != ""){
        File file = File(filePath);
        file.writeAsStringSync(encrypted);
        print('The file was successfully encrypted.');
      } else {
        print('The file was not successfully encrypted.');
      }
    }
    on Exception catch (e) {
      print('The file encryption failed.');
      print(e.toString());
    }
  }

// Decrypts the content of the file located by the 'filePath'.
  void decryptFile({required filePath}) {
    String decrypted = "";

    try {
      // Read file content
      String fileContent = File(filePath).readAsStringSync();

      // Encrypt content
      decrypted = this.decryptText(encrypted: fileContent);

      // If encryption successful, update the file with the encrypted text
      if(decrypted != ""){
        File file = File(filePath);
        file.writeAsStringSync(decrypted);
        print('The file was successfully decrypted.');
      } else {
        print('The file was not successfully decrypted.');
      }
    }
    on Exception catch (e) {
      print('The file decryption failed.');
      print(e.toString());
    }
  }

  // Dispose all the resources
  Future<void> disposeResources() async {
    print('Disposing encryption/decryption resources');
    // For resource to dispose once the application is closed
  }
}
