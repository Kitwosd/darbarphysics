import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  level: kReleaseMode ? Level.warning : Level.debug,
  printer: PrettyPrinter(
    methodCount: 0,
    lineLength: 80,
    colors: !kReleaseMode,
    printEmojis: true,
  ),
);
