import 'package:atlas_mobile_pi1/core/theme/app_theme.dart';
import 'package:atlas_mobile_pi1/services/preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AtlasApp extends StatelessWidget {
  const AtlasApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final preferences = context.watch<PreferencesService>();

    return MaterialApp.router(
      title: 'Atlas',
      debugShowCheckedModeBanner: false,
      themeMode: preferences.themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      locale: preferences.currentLanguage,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt'),
        Locale('en'),
        Locale('es'),
      ],
    );
  }
}
