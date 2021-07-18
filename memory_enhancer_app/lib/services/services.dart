//**************************************************************
// Application Services
// Author: Christian Ahmed
//**************************************************************
import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/speech/native_speech_service.dart';
import 'package:memory_enhancer_app/file_operations.dart';
import 'package:memory_enhancer_app/services/encryption/encryption_service.dart';
import 'package:memory_enhancer_app/services/text_to_speech/text_to_speech_service.dart';

import 'get_it.dart';

// The navigation router (i.e. controller)
final appRouter = AppRouter();

// The custom-built speech service (Singleton)
NativeSpeechService get speechService {
  return getIt.get<NativeSpeechService>();
}

// File handler
FileOperations fileOperations = FileOperations();

// The encryption/decryption service (Singleton)
// Encrypt and decrypt texts and files
EncryptionService get encryptionService {
  return getIt.get<EncryptionService>();
}

// Text to Speech Service (Singleton)
// Synthesize a text and play it as a voice
TextToSpeechService get textToSpeechService {
  return getIt.get<TextToSpeechService>();
}

