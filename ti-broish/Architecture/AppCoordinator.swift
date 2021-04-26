//
//  AppCoordinator.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 21.04.21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: Properties
    let window: UIWindow?
    
    // MARK: Coordinator
    init(window: UIWindow?) {
        self.window = window
        super.init()
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    override func start() {
        childCoordinators.first?.start()
    }
}

