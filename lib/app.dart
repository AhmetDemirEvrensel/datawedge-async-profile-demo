import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';
import 'profile_demo/presentation/profile_demo_page.dart';

class ProfileReadinessDemoApp extends StatefulWidget {
  const ProfileReadinessDemoApp({
    super.key,
    this.initialLocale = const Locale('tr'),
  });

  final Locale initialLocale;

  @override
  State<ProfileReadinessDemoApp> createState() =>
      _ProfileReadinessDemoAppState();
}

class _ProfileReadinessDemoAppState extends State<ProfileReadinessDemoApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void _changeLocale(Locale locale) {
    if (locale != _locale) {
      setState(() => _locale = locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF3155D9);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
      home: ProfileDemoPage(locale: _locale, onLocaleChanged: _changeLocale),
    );
  }
}
