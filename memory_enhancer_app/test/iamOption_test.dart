// Test class for the encryption/decryption service
// Author: Ayodeji Famudehin

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:memory_enhancer_app/services/speech/custom/IamOptions.dart';

void main() {

  test("IamOptions instantiation test", () async {

    IamOptions options = IamOptions(iamApiKey: "my-api-test-key", url: "https://amazing.team");

    expect(options.iamApiKey, "my-api-test-key");
    expect(options.url, "https://amazing.team");
  });

  test("IamOptions build test - Failure", () async {

    IamOptions options = IamOptions(iamApiKey: "my-api-test-key", url: "https://amazing.team");
    expect(options.iamApiKey, "my-api-test-key");
    expect(options.url, "https://amazing.team");

    expect(() => options.build(), throwsA(isA<TypeError>()));
  });

  test("IamOptions build test - Success", () async {

    IamOptions options = IamOptions(
        iamApiKey: "b1rIMw3vSUe86N7BK7efz6cDorY-g1qTxUPkC2dmmJ6J",
        url: "wss://api.us-east.speech-to-text.watson.cloud.ibm.com/instances/e8365b62-16bf-48e8-8bd8-cc9b0b556e58");
    expect(options.iamApiKey, "b1rIMw3vSUe86N7BK7efz6cDorY-g1qTxUPkC2dmmJ6J");
    expect(options.url, "wss://api.us-east.speech-to-text.watson.cloud.ibm.com/instances/e8365b62-16bf-48e8-8bd8-cc9b0b556e58");

    IamOptions builtOptions = await options.build();
    expect(builtOptions.accessToken, options.accessToken);
    expect(builtOptions.refreshToken, options.refreshToken);
    expect(builtOptions.tokenType, options.tokenType);
    expect(builtOptions.expiresIn, options.expiresIn);
    expect(builtOptions.expiration, options.expiration);
    expect(builtOptions.scope, options.scope);

  });

}