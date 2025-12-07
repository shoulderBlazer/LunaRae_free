import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';
import 'screens/story_generator_screen.dart';
import 'services/ad_service.dart';
import 'services/analytics_service.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    // Initialize Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    
    await AdService.initialize();
    await AnalyticsService.logAppOpened();
    runApp(const LunaRaeApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class LunaRaeApp extends StatelessWidget {
  const LunaRaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LunaRae',
      theme: LunaTheme.lightTheme(),
      darkTheme: LunaTheme.darkTheme(),
      themeMode: ThemeMode.system, // Automatically adapts to system light/dark mode
      home: const StoryGeneratorScreen(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [AnalyticsService.observer],
    );
  }
} 