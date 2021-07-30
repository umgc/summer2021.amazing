// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'data_processing/data_processing.dart' as _i3;
import 'encryption/encryption_service.dart' as _i4;
import 'file_operations/file_operations.dart' as _i5;
import 'speech/custom/speech_to_text_service.dart' as _i6;
import 'speech/custom/text_to_speech_service.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.DataProcessingService>(_i3.DataProcessingService());
  gh.singleton<_i4.EncryptionService>(_i4.EncryptionService());
  gh.singleton<_i5.FileOperations>(_i5.FileOperations());
  gh.singleton<_i6.SpeechToTextService>(_i6.SpeechToTextService());
  gh.singleton<_i7.TextToSpeechService>(_i7.TextToSpeechService());
  return get;
}
