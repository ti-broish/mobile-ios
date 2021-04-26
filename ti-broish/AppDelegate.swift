//
//  AppDelegate.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var screenCoordinator: ScreenCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool
    {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(navigationBarClass: TibNavigationBar.self, toolbarClass: nil)
        screenCoordinator = ScreenCoordinator(navigationController: window?.rootViewController as! UINavigationController)
        screenCoordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}

