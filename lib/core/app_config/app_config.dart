import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String baseUrl;
  AppConfig({required this.baseUrl});
}

final devConfig = AppConfig(baseUrl: dotenv.env['BASE_URL']!);
final prodConfig = AppConfig(baseUrl: dotenv.env['BASE_URL']!);
