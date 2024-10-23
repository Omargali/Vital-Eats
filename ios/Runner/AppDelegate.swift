import Flutter
import UIKit
import GoogleMaps 

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyA6hOwJM0xl2zbiV5nrpuHtMagS12y2Kr4")   

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
