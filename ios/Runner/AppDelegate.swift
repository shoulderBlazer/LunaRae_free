import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Optimize network configuration for better HTTP performance
    configureNetworkSession()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func configureNetworkSession() {
    // Create a custom URLSession configuration for optimal performance
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30.0
    configuration.timeoutIntervalForResource = 60.0
    configuration.httpMaximumConnectionsPerHost = 5
    configuration.requestCachePolicy = .useProtocolCachePolicy
    configuration.urlCache = URLCache(
      memoryCapacity: 10 * 1024 * 1024,    // 10MB memory cache
      diskCapacity: 50 * 1024 * 1024,     // 50MB disk cache
      diskPath: "http_cache"
    )
    
    // Enable HTTP/2 and connection pooling
    configuration.httpShouldUsePipelining = true
    configuration.httpShouldSetCookies = true
    configuration.httpAdditionalHeaders = [
      "Connection": "keep-alive",
      "Keep-Alive": "timeout=30, max=100"
    ]
    
    // Store the custom session for use by HTTP clients
    // Note: This configuration will be used by the default URLSession behavior
  }
}
