//
//  AppDelegate.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//

import UIKit
import Firebase
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool
    {
        TibTheme.changeAppearance()
        FirebaseApp.configure()
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
        
        registerRemoteNotifications(for: application)
        
        setupAvSession()
        
        return true
    }

    // MARK: Private Methods
    
    private func registerRemoteNotifications(for application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                }
                
                if granted {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func setupAvSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = String(data: deviceToken, encoding: .utf8) else { return }
        Messaging.messaging().delegate = self
        print("APNS token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")
    }
    
}
