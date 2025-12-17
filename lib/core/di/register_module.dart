import 'package:durbar_physics/core/network/api_client.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  // Registering ApiClient as a singleton
  // Since ApiClient is a singleton by itself using factory/static, we might just need to register it here if we want to inject it.
  // However, ApiClient in the codebase is already a singleton.
  // Let's verify ApiClient usage. It seems to have init method.
  // Ideally, we should refactor ApiClient to be injectable, but for now let's just register it.
  @singleton
  ApiClient get apiClient => ApiClient();
}
