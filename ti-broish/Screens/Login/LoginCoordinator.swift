//
//  LoginCoordinator.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import UIKit
import Firebase

final class LoginCoordinator: Coordinator {
    
    private var contentContainerCoordinator: ContentContainerCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        contentContainerCoordinator = ContentContainerCoordinator(navigationController: self.navigationController)
    }
    
    override func start() {
        showLoginScreen()
    }
    
    func showHomeScreen() {
        let controller = ContentContainerViewController()
        controller.coordinator = contentContainerCoordinator
        
        navigationController.viewControllers.removeAll()
        pushController(controller, animated: false)
    }
    
    func showLoginScreen() {
        let controller = LoginViewController(nibName: LoginViewController.nibName, bundle: nil)
        controller.viewModel.coordinator = self
        
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
