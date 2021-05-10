//
//  HomeCoordinator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.05.21.
//

import UIKit

final class HomeCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let controller = ContentContainerViewController()
        
        navigationController.viewControllers.removeAll()
        pushController(controller, animated: false)
    }
    
    // MARK: - Private methods
    
    private func pushController(_ controller: UIViewController, hideNavigationBar: Bool = false, animated: Bool = true) {
        navigationController.navigationBar.isHidden = hideNavigationBar
        navigationController.pushViewController(controller, animated: animated)
    }
}
