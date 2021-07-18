// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'encryption/encryption_service.dart' as _i3;
import 'speech/native_speech_service.dart' as _i4;
import 'text_to_speech/text_to_speech_service.dart'
    as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  gh.singleton<_i3.EncryptionService>(_i3.EncryptionService());
  gh.singleton<_i4.NativeSpeechService>(_i4.NativeSpeechService());
  gh.singleton<_i5.TextToSpeechService>(_i5.TextToSpeechService());
  return get;
}
