//**************************************************************
// Application Services
// Author: Christian Ahmed
//**************************************************************
import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/data_processing/data_processing.dart';
import 'package:memory_enhancer_app/services/speech/custom/speech_to_text_service.dart';
import 'package:memory_enhancer_app/services/speech/custom/text_to_speech_service.dart';
import 'package:memory_enhancer_app/services/file_operations/file_operations.dart';
import 'package:memory_enhancer_app/services/encryption/encryption_service.dart';

import 'get_it.dart';

// The navigation router (i.e. controller)
final appRouter = AppRouter();

// The custom-built speech-to-text service (Singleton)
SpeechToTextService get speechService {
  return getIt.get<SpeechToTextService>();
}

// The custom-built text-to-speech service (Singleton)
TextToSpeechService get textToSpeechService {
  return getIt.get<TextToSpeechService>();
}

// File handler
FileOperations get fileOperations {
  return getIt.get<FileOperations>();
}

// The encryption/decryption service (Singleton)
// Encrypt and decrypt texts and files
EncryptionService get encryptionService {
  return getIt.get<EncryptionService>();
}

// The Data Processing Service (Singleton)
DataProcessingService get dataProcessingService {
  return getIt.get<DataProcessingService>();
}


