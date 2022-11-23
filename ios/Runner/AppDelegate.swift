import UIKit
import Flutter
import Firebase
import FirebaseCore
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  GMSServices.provideAPIKey("AIzaSyDlNA3ovqzr3XolsRkw0lS44lQEL-w3bS8")
  FirebaseApp.configure()
  GeneratedPluginRegistrant.register(with: self)
  if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as?UNUserNotificationCenterDelegate
  }
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
