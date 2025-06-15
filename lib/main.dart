import 'package:final_thriving_together/pages/Settings.dart';
import 'package:final_thriving_together/pages/articles_page.dart';
import 'package:final_thriving_together/pages/diagnoses_page.dart';
import 'package:final_thriving_together/pages/exams_page.dart';
import 'package:final_thriving_together/pages/home_page.dart';
import 'package:final_thriving_together/pages/loading_screen.dart';
import 'package:final_thriving_together/registration/User_credentials.dart';
import 'package:final_thriving_together/registration/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_thriving_together/Theme_provider.dart';
import 'package:final_thriving_together/Splash_Screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:final_thriving_together/l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load any saved credentials when the app starts
  await UserCredentials.loadSavedCredentials();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      locale: themeProvider.currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.all,
      debugShowCheckedModeBanner: false,
      home: AppStartupScreen(),
      theme: themeProvider.getTheme,
      routes: {
        '/home': (context) => const HomePage(username: "zeyad", password: "12345"),
        '/login': (context) => const LoginForm(),
        '/articles': (context) => const Articlespage(),
        '/diagnoses': (context) => const Diagnosespage(),
        '/exams': (context) => const Examspage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}

class AppStartupScreen extends StatelessWidget {
  Future<void> _initializeApp() async {
    // Simulate app initialization
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeApp(),
      builder: (context, snapshot) {
        return SplashScreen();
      },
    );
  }
}