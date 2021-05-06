//
//  LoginCoordinator.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        if isLoggedIn() {
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
    
    private func isLoggedIn() -> Bool {
        guard let token = LocalStorage.User().getJwt() else {
            return false
        }
        
        return token.count > 0
    }
    
    private func pushController(_ controller: UIViewController, hideNavigationBar: Bool = false, animated: Bool = true) {
        navigationController.navigationBar.isHidden = hideNavigationBar
        navigationController.pushViewController(controller, animated: animated)
    }
}
