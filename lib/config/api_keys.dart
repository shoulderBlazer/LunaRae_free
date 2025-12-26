import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;

class ApiKeys {
  static String get openAiKey {
    // Try environment variable first (for CI/CD builds)
    const envKey = String.fromEnvironment('OPENAI_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    
    // Fallback to .env file for development
    return dotenv.env['OPENAI_API_KEY'] ?? '';
  }
}
