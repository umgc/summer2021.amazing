import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/speech/speech_service.dart';

import 'get_it.dart';

final appRouter = AppRouter();

SpeechService get speechService {
  return getIt.get<SpeechService>();
}