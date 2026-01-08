import 'dart:async';

import 'package:durbar_physics/core/app_config/app_config.dart';
import 'package:durbar_physics/core/di/injection.dart';
import 'package:durbar_physics/core/hive_services/hive_services.dart';
import 'package:durbar_physics/core/logger/app_logger.dart';
import 'package:durbar_physics/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Hive (local storage)
      await HiveServices.init();

      // Load Environment Variables
      await dotenv.load(fileName: ".env");

      // Configure Dependency Injection
      await configureDependencies();

      // Initialize ApiClient
      // Logic Initialization (ApiClient)
      final authBox = Hive.box('authBox');
      final String? accessToken = authBox.get('accessToken');
      ApiClient().init(baseUrl: devConfig.baseUrl, accessToken: accessToken);

      runApp(await builder());
    },
    (error, stackTrace) {
      logger.e('App Crash', error: error, stackTrace: stackTrace);
    },
  );
}
