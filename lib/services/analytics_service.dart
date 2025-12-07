import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // App opened - call on app launch
  static Future<void> logAppOpened() async {
    await _analytics.logEvent(name: 'app_opened');
  }

  // Screen 1 viewed
  static Future<void> logScreenPromptOpened() async {
    await _analytics.logEvent(name: 'screen_prompt_opened');
  }

  // Screen 2 viewed
  static Future<void> logScreenStoryOpened() async {
    await _analytics.logEvent(name: 'screen_story_opened');
  }

  // Generate button tapped
  static Future<void> logStoryGeneratePressed() async {
    await _analytics.logEvent(name: 'story_generate_pressed');
  }

  // API returns story successfully
  static Future<void> logStoryGenerateSuccess({int? storyLength}) async {
    await _analytics.logEvent(
      name: 'story_generate_success',
      parameters: {
        'story_length': storyLength ?? 0,
      },
    );
  }

  // API throws error
  static Future<void> logStoryGenerateFailed(String errorMessage) async {
    await _analytics.logEvent(
      name: 'story_generate_failed',
      parameters: {
        'error_message': errorMessage.length > 100 
            ? errorMessage.substring(0, 100) 
            : errorMessage,
      },
    );
  }

  // Banner ad displayed
  static Future<void> logAdBannerShown() async {
    await _analytics.logEvent(name: 'ad_banner_shown');
  }

  // Interstitial ad displayed (after story)
  static Future<void> logAdInterstitialShown() async {
    await _analytics.logEvent(name: 'ad_interstitial_shown');
  }

  // User scrolled to the bottom of the story content
  static Future<void> logStoryScrolledToBottom() async {
    await _analytics.logEvent(name: 'story_scrolled_to_bottom');
  }

  // OpenAI quota hit (status 429)
  static Future<void> logApiQuotaError() async {
    await _analytics.logEvent(name: 'api_quota_error');
    
    await _crashlytics.recordError(
      Exception('OpenAI API Quota Error'),
      StackTrace.current,
      reason: 'OpenAI API quota exceeded (429)',
      fatal: false,
    );
  }

  // General OpenAI API error logging
  static Future<void> logOpenAIError({
    required int statusCode,
    required String errorBody,
  }) async {
    // Check for quota error specifically
    if (statusCode == 429) {
      await logApiQuotaError();
    }
    
    await logStoryGenerateFailed('API error $statusCode: $errorBody');

    // Also log to Crashlytics for detailed tracking
    await _crashlytics.recordError(
      Exception('OpenAI API Error: $statusCode'),
      StackTrace.current,
      reason: 'OpenAI API returned error: $errorBody',
      fatal: false,
    );
  }

  // Record non-fatal errors to Crashlytics
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  // Log custom message to Crashlytics
  static Future<void> log(String message) async {
    await _crashlytics.log(message);
  }
}
