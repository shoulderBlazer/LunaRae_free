import 'dart:convert';
import 'package:http/http.dart' as http;
import 'analytics_service.dart';

class StoryService {
  final String apiKey;
  StoryService(this.apiKey);

  Future<String> generateStory(String input) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");


    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-4.1-mini",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are LunaRae, a gentle storyteller who writes calm, happy bedtime stories for children ages 2 to 10. "
                  "Stories must avoid fear, danger, sadness, violence, and villains. "
                  "Every story should be relaxing, positive, kind, imaginative, and end with peaceful sleep."
            },
            {
              "role": "user",
              "content": "Create a short bedtime story about: $input"
            }
          ],
          "max_tokens": 700,
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        try {
          final story = data["choices"][0]["message"]["content"]?.trim() ??
              "🌙 A soft and peaceful dream…";
          
          // Log success with story length
          await AnalyticsService.logStoryGenerateSuccess(storyLength: story.length);
          
          return story;
        } catch (e) {
          await AnalyticsService.logStoryGenerateFailed('Parse error: $e');
          return "🌙 A soft and peaceful dream…";
        }
      } else {
        // Log OpenAI API error
        await AnalyticsService.logOpenAIError(
          statusCode: response.statusCode,
          errorBody: response.body,
        );
        throw Exception("Failed to generate story: ${response.body}");
      }
    } catch (e) {
      if (e is! Exception || !e.toString().contains('Failed to generate story')) {
        // Log unexpected errors (network issues, etc.)
        await AnalyticsService.logStoryGenerateFailed(e.toString());
        await AnalyticsService.recordError(e, StackTrace.current, reason: 'Story generation error');
      }
      rethrow;
    }
  }
}
