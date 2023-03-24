//
//  AppCoordinator.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 21.04.21.
//

import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
        super.init()
        
        let navigationController = UINavigationController(navigationBarClass: TibNavigationBar.self, toolbarClass: nil)
        configureNavigationController(navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        addChildCoordinator(ContentContainerCoordinator(navigationController: navigationController))
    }
    
    override func start() {
        childCoordinators.first?.start()
    }
    
    func logout() {
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            return
        }
        
        removeAllChildCoordinators()
        navigationController.viewControllers.removeAll()
        
        let screenCoordinator = LoginCoordinator(navigationController: navigationController)
        addChildCoordinator(screenCoordinator)
        
        start()
    }
    
    func showProtocol(id: String) {
        guard let contentCoordinator = childCoordinators.first as? ContentContainerCoordinator else {
            return
        }
        
        contentCoordinator.showProtocol(id: id)
    }
    
    func showProtocols() {
        showRemoteNotificationViewController(nibName: ProtocolsTableViewController.nibName)
    }
    
    func showViolation(id: String) {
        guard let contentCoordinator = childCoordinators.first as? ContentContainerCoordinator else {
            return
        }
        
        contentCoordinator.showViolation(id: id)
    }
    
    func showViolations() {
        showRemoteNotificationViewController(nibName: ViolationsTableViewController.nibName)
    }
    
    // MARK: - Private methods
    
    private func configureNavigationController(_ navigationController: UINavigationController) {
        let theme = TibTheme()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = theme.navigationBarTintColor
        appearance.titleTextAttributes = [.foregroundColor: theme.navigationBarTextColor]
        
        navigationController.navigationBar.tintColor = theme.navigationBarTextColor
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func showRemoteNotificationViewController(nibName: String) {
        guard
            let contentCoordinator = childCoordinators.first as? ContentContainerCoordinator,
            let viewController = contentCoordinator.navigationController.children.first as? ContentContainerViewController
        else {
            return
        }
        
        viewController.showRemoteNotificationViewController(nibName: nibName)
    }
}

