//
//  AppCoordinator.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 21.04.21.
//

import SFBaseKit

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
        
        let exampleCoordinator = ExampleCoordinator(navigationController: navigationController)
        addChildCoordinator(exampleCoordinator)
    }
    
    override func start() {
        // Start the next coordinator in the heirarchy or the current module rootViewModel
        childCoordinators.first?.start()
    }
}

