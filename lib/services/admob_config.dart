import 'dart:io';
import 'package:flutter/foundation.dart';

/// Centralized AdMob configuration service.
/// 
/// - Automatically detects Android vs iOS platform
/// - Automatically detects debug vs release mode
/// - Uses Google test ad IDs in debug mode ONLY
/// - Uses production ad IDs in release mode ONLY
/// - Prevents test ads from ever showing in production
/// - Prevents real ads from ever showing in debug
class AdMobConfig {
  AdMobConfig._(); // Private constructor - no instantiation

  // ============================================================
  // PRODUCTION AD UNIT IDs - REPLACE WITH YOUR REAL IDs
  // ============================================================
  
  // Android Production Ad Unit IDs
  static const String _androidBannerScreen1 = 'ca-app-pub-5203847313376900/9777735905';
  static const String _androidBannerScreen2 = 'ca-app-pub-5203847313376900/9937518005';
  static const String _androidInterstitialAfterStory = 'ca-app-pub-5203847313376900/2843935547';
  
  // iOS Production Ad Unit IDs
  static const String _iosBannerScreen1 = 'ca-app-pub-5203847313376900/4034277024';
  static const String _iosBannerScreen2 = 'ca-app-pub-5203847313376900/7904690535';
  static const String _iosInterstitialAfterStory = 'ca-app-pub-5203847313376900/9590033641';

  // ============================================================
  // GOOGLE TEST AD UNIT IDs (Official test IDs from Google)
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  // ============================================================
  
  // Android Test Ad Unit IDs
  static const String _testAndroidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String _testAndroidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  
  // iOS Test Ad Unit IDs
  static const String _testIosBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testIosInterstitial = 'ca-app-pub-3940256099942544/4411468910';

  // ============================================================
  // PLATFORM & MODE DETECTION
  // ============================================================

  /// Returns true if running on Android
  static bool get isAndroid => Platform.isAndroid;

  /// Returns true if running on iOS
  static bool get isIOS => Platform.isIOS;

  /// Returns true if running in debug mode (kReleaseMode is a compile-time constant)
  static bool get isDebugMode => !kReleaseMode;

  /// Returns true if running in release mode
  static bool get isReleaseMode => kReleaseMode;

  // ============================================================
  // SAFE AD UNIT ID GETTERS
  // These methods guarantee:
  // - Test ads ONLY in debug mode
  // - Production ads ONLY in release mode
  // ============================================================

  /// Banner Ad ID for Screen 1
  /// Returns test ID in debug, production ID in release
  static String get bannerAdIdScreen1 {
    if (isDebugMode) {
      return _getTestBannerId();
    }
    return _getProductionBannerIdScreen1();
  }

  /// Banner Ad ID for Screen 2
  /// Returns test ID in debug, production ID in release
  static String get bannerAdIdScreen2 {
    if (isDebugMode) {
      return _getTestBannerId();
    }
    return _getProductionBannerIdScreen2();
  }

  /// Interstitial Ad ID for After Story
  /// Returns test ID in debug, production ID in release
  static String get interstitialAdIdAfterStory {
    if (isDebugMode) {
      return _getTestInterstitialId();
    }
    return _getProductionInterstitialIdAfterStory();
  }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  /// Gets the appropriate test banner ID for the current platform
  static String _getTestBannerId() {
    assert(isDebugMode, 'Test ads should never be requested in release mode');
    if (isAndroid) {
      return _testAndroidBanner;
    } else if (isIOS) {
      return _testIosBanner;
    }
    throw UnsupportedError('Unsupported platform for AdMob');
  }

  /// Gets the appropriate test interstitial ID for the current platform
  static String _getTestInterstitialId() {
    assert(isDebugMode, 'Test ads should never be requested in release mode');
    if (isAndroid) {
      return _testAndroidInterstitial;
    } else if (isIOS) {
      return _testIosInterstitial;
    }
    throw UnsupportedError('Unsupported platform for AdMob');
  }

  /// Gets production banner ID for Screen 1
  static String _getProductionBannerIdScreen1() {
    assert(isReleaseMode, 'Production ads should never be requested in debug mode');
    if (isAndroid) {
      return _androidBannerScreen1;
    } else if (isIOS) {
      return _iosBannerScreen1;
    }
    throw UnsupportedError('Unsupported platform for AdMob');
  }

  /// Gets production banner ID for Screen 2
  static String _getProductionBannerIdScreen2() {
    assert(isReleaseMode, 'Production ads should never be requested in debug mode');
    if (isAndroid) {
      return _androidBannerScreen2;
    } else if (isIOS) {
      return _iosBannerScreen2;
    }
    throw UnsupportedError('Unsupported platform for AdMob');
  }

  /// Gets production interstitial ID for After Story
  static String _getProductionInterstitialIdAfterStory() {
    assert(isReleaseMode, 'Production ads should never be requested in debug mode');
    if (isAndroid) {
      return _androidInterstitialAfterStory;
    } else if (isIOS) {
      return _iosInterstitialAfterStory;
    }
    throw UnsupportedError('Unsupported platform for AdMob');
  }

  // ============================================================
  // DEBUG HELPERS
  // ============================================================

  /// Logs the current configuration (only in debug mode)
  static void debugPrintConfig() {
    if (isDebugMode) {
      debugPrint('╔══════════════════════════════════════════════════════════╗');
      debugPrint('║              AdMob Configuration Status                   ║');
      debugPrint('╠══════════════════════════════════════════════════════════╣');
      debugPrint('║ Platform: ${isAndroid ? "Android" : isIOS ? "iOS" : "Unknown"}');
      debugPrint('║ Mode: ${isDebugMode ? "DEBUG (Test Ads)" : "RELEASE (Production Ads)"}');
      debugPrint('║ Banner Screen 1: ${bannerAdIdScreen1}');
      debugPrint('║ Banner Screen 2: ${bannerAdIdScreen2}');
      debugPrint('║ Interstitial: ${interstitialAdIdAfterStory}');
      debugPrint('╚══════════════════════════════════════════════════════════╝');
    }
  }

  /// Validates that production IDs have been configured
  /// Call this during app initialization in release mode
  static bool validateProductionConfig() {
    if (isReleaseMode) {
      final hasValidAndroidConfig = !_androidBannerScreen1.contains('XXXX') &&
          !_androidBannerScreen2.contains('XXXX') &&
          !_androidInterstitialAfterStory.contains('XXXX');
      
      final hasValidIosConfig = !_iosBannerScreen1.contains('XXXX') &&
          !_iosBannerScreen2.contains('XXXX') &&
          !_iosInterstitialAfterStory.contains('XXXX');

      if (isAndroid && !hasValidAndroidConfig) {
        debugPrint('⚠️ WARNING: Android production Ad IDs not configured!');
        return false;
      }
      if (isIOS && !hasValidIosConfig) {
        debugPrint('⚠️ WARNING: iOS production Ad IDs not configured!');
        return false;
      }
    }
    return true;
  }
}
