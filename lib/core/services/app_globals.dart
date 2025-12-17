import 'package:durbar_physics/core/routing/navigation_service.dart';
import 'package:durbar_physics/core/theme/app_colors.dart';
import 'package:durbar_physics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

BuildContext get _context => NavigationService.navigationKey.currentContext!;

// localization (global)
AppLocalizations get l10 => AppLocalizations.of(_context)!;

//Theme Colors(global)
ColorScheme get appColors =>
    Theme.of(_context).colorScheme; // for primary and secondary

AppColors get customColors =>
    Theme.of(_context).extension<AppColors>()!; // for the custom colors
