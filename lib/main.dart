import 'package:dubar_physics/core/localization/bloc/localization_bloc.dart';
import 'package:dubar_physics/core/routing/app_router.dart';
import 'package:dubar_physics/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => LocalizationBloc())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
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
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
