import 'package:dubar_physics/core/app_config/app_config.dart';
import 'package:dubar_physics/core/di/injection.dart';
import 'package:dubar_physics/core/localization/bloc/localization_bloc.dart';
import 'package:dubar_physics/core/routing/app_router.dart';
import 'package:dubar_physics/core/theme/app_theme.dart';
import 'package:dubar_physics/core/theme/theme_cubit.dart';
import 'package:dubar_physics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dubar_physics/core/network/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // loading the .env file before giving to apiclient
  await dotenv.load(fileName: ".env");
  await configureDependencies();

  //Api Client base url passing from env
  ApiClient().init(baseUrl: devConfig.baseUrl);

  //BlocObserver
  // Bloc.observer = AppBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocalizationBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: MyApp(config: devConfig),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppConfig config;
 
  const MyApp({super.key, required this.config});
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

                //routing
                routerConfig: appRouter,

                //localization
                locale: state.locale,
                supportedLocales: const [Locale('en'), Locale('ne')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],

                // builder: (context, child) {
                //   // Wrap all routed screens with SafeArea globally
                //   return SafeArea(child: child!);
                // },

                //Theme (Dark and light mode)
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
