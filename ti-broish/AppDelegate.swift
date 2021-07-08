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
    
    private (set) var isKeyboardVisible = false
    
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
        addObservers()
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        if let protocolId = userInfo["protocol_id"] as? String {
            appCoordinator?.showProtocol(id: protocolId)
        } else if let violationId = userInfo["violation_id"] as? String {
            appCoordinator?.showViolation(id: violationId)
        } else if let screen = userInfo["screen"] as? String {
            switch screen {
            case "protocols":
                appCoordinator?.showProtocols()
            case "violations":
                appCoordinator?.showViolations()
            default:
                break
            }
        } else {
            print("remote notification userInfo: \(userInfo)")
        }
    }
    
    // MARK: - Private Methods
    
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
    
    private func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        isKeyboardVisible = true
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        isKeyboardVisible = false
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard Messaging.messaging().fcmToken != nil else {
            return
        }
        
        Messaging.messaging().delegate = self
        APIManager.shared.sendAPNsToken { _ in }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        APIManager.shared.sendAPNsToken { _ in }
    }
}
