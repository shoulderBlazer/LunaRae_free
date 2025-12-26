import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static String get openAiKey {
    final key = dotenv.env['OPENAI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('OPENAI_API_KEY not found in environment variables');
    }
    return key;
  }
}
