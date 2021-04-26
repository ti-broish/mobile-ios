//
//  ScreenCoordinator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/23/21.
//  
//

import UIKit

final class ScreenCoordinator: Coordinator {
    
    private var isLoggedIn = false // TODO: - refactor
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        if isLoggedIn {
            showHomeScreen()
        } else {
            showLoginScreen()
        }
    }
    
    func showHomeScreen() {
        let controller = ContentContainerViewController()
        controller.coordinator = self
        
        navigationController.viewControllers.removeAll()
        pushController(controller, animated: false)
    }
    
    func showLoginScreen() {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        controller.coordinator = self
        
        navigationController.viewControllers.removeAll()
        pushController(controller, hideNavigationBar: true, animated: false)
    }
    
    func showRegistrationScreen() {
        let controller = RegistrationViewController(nibName: RegistrationViewController.nibName, bundle: nil)
        
        pushController(controller)
    }
    
    func showResetPasswordScreen() {
        let controller = ResetPasswordViewController(nibName: ResetPasswordViewController.nibName, bundle: nil)
        
        pushController(controller)
    }
    
    // MARK: - Private methods
    
    private func pushController(_ controller: UIViewController, hideNavigationBar: Bool = false, animated: Bool = true) {
        navigationController.navigationBar.isHidden = hideNavigationBar
        navigationController.pushViewController(controller, animated: animated)
    }
}
