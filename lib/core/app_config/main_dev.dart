import 'package:durbar_physics/app.dart';
import 'package:durbar_physics/core/app_config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MainDev {
  static Future<void> main() async {
    await dotenv.load(fileName: '.env');
    runApp(MyApp(config: devConfig));
  }
}
