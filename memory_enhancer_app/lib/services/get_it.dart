import 'get_it.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

// Ahmed: Execute below to generated dependency injection

// flutter packages pub run build_runner watch
// - OR -
// flutter packages pub run build_runner build

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)

void configureDependencies() => $initGetIt(getIt);


