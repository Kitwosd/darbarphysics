import 'package:durbar_physics/core/app_config/app_config.dart';
import 'package:durbar_physics/core/di/app_providers.dart';
import 'package:durbar_physics/core/localization/bloc/localization_bloc.dart';
import 'package:durbar_physics/core/routing/app_router.dart';
import 'package:durbar_physics/core/theme/app_theme.dart';
import 'package:durbar_physics/core/theme/theme_cubit.dart';
import 'package:durbar_physics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  final AppConfig config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: providers, child: const AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return ScreenUtilInit(
              designSize: const Size(428, 926),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, __) => MaterialApp.router(
                title: "Durbar Physics",

                // Routing
                routerConfig: appRouter,

                // Localization
                locale: state.locale,
                supportedLocales: const [Locale('en'), Locale('ne')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                // Theme
                themeMode: themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                debugShowCheckedModeBanner: false,
              ),
            );
          },
        );
      },
    );
  }
}
