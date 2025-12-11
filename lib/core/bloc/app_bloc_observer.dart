import 'package:dubar_physics/core/logger/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);

    logger.d(
      'Bloc | ${bloc.runtimeType} | ${change.currentState} → ${change.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e(
      'BLOC ERROR | ${bloc.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );

    super.onError(bloc, error, stackTrace);
  }
}
