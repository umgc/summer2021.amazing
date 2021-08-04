// Test class for the encryption/decryption service
// Author: Ayodeji Famudehin

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:memory_enhancer_app/services/encryption/encryption_service.dart';

void main() {

  // Create instance of service
  EncryptionService service = new EncryptionService();

  test("Test Text Encryption and Decryption", () async {

    // Text to encrypt and decrypt
    String textToEncrypt = "The amazing team is amazing";

    // Validate text encryption
    print("********* TEST : Text Encryption *********");
    print("Text to encrypt : " + textToEncrypt);
    String encryptedText = service.encryptText(text: textToEncrypt);
    print("Encrypted text : " + encryptedText);

    print("");

    // Validate text decryption
    print("********* TEST : Text Decryption *********");
    print("Text to encrypt : " + encryptedText);
    String decryptedText = service.decryptText(encrypted: encryptedText);
    print("Decrypted text : " + decryptedText);

    expect(textToEncrypt, decryptedText);
  });

  test("Test File Encryption and Decryption", () async {
    // Test file to encrypt and decrypt
    String testFilePath = "test/test_data/encryption_data_test_file.txt";
    String originalFileContent = File(testFilePath).readAsStringSync();

    // Validate text encryption
    print("\n********* TEST : File Encryption *********");
    print("Test file to encrypt : " + testFilePath);
    print("Test file content before encryption: " + originalFileContent + '\n');
    service.encryptFile(filePath: testFilePath);
    print("Test file content after encryption: " + File(testFilePath).readAsStringSync() + '\n');

    print("");

    // Validate text decryption
    print("\n********* TEST : File Decryption *********");
    print("Test file to encrypt : " + testFilePath);
    print("Test file content before decryption: " + File(testFilePath).readAsStringSync() + '\n');
    service.decryptFile(filePath: testFilePath);
    print("Test file content after decryption: " + File(testFilePath).readAsStringSync() + '\n');

    expect(originalFileContent, File(testFilePath).readAsStringSync());
  });

}