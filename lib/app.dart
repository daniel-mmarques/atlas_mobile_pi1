import 'package:atlas_mobile_pi1/core/theme/app_theme.dart';
import 'package:atlas_mobile_pi1/core/theme/app_theme_id.dart';
import 'package:atlas_mobile_pi1/l10n/app_localizations.dart';
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
    final themeId = context.select<PreferencesService, AppThemeId>(
      (p) => p.appThemeId,
    );
    final locale = context.select<PreferencesService, Locale>(
      (p) => p.currentLanguage,
    );

    return MaterialApp.router(
      title: 'Atlas',
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: AppThemes.of(themeId),
      // Instant swap avoids light↔dark mid-frames where sheet chrome and
      // ThemeExtension tokens can disagree.
      themeAnimationDuration: Duration.zero,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
