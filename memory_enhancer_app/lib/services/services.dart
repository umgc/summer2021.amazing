//**************************************************************
// Application Services
// Author: Christian Ahmed
//**************************************************************
import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/speech/speech_service.dart';
import 'package:memory_enhancer_app/services/encryption/encryption_service.dart';

import 'get_it.dart';

// The navigation router (i.e. controller)
final appRouter = AppRouter();

// The speech service (Singleton)
SpeechService get speechService {
  return getIt.get<SpeechService>();
}

// The encryption/decryption service (Singleton)
EncryptionService get encryptionService {
  return getIt.get<EncryptionService>();
}