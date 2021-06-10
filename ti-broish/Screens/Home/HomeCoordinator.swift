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
    
    func loadViewController(nibName: String) {
        let controller: UIViewController?
        
        switch nibName {
        case SendProtocolViewController.nibName:
            controller = SendProtocolViewController.init(nibName: nibName, bundle: nil)
        case SendViolationViewController.nibName:
            controller = SendViolationViewController.init(nibName: nibName, bundle: nil)
        case TermsViewController.nibName:
            controller = TermsViewController.init(nibName: nibName, bundle: nil)
        default:
            controller = nil
            assertionFailure("Invalid or not handled view controller nibName")
            break
        }
        
        if let _controller = controller {
            pushController(_controller)
        }
    }
    
    // MARK: - Private methods
    
    private func pushController(_ controller: UIViewController, hideNavigationBar: Bool = false, animated: Bool = true) {
        navigationController.navigationBar.isHidden = hideNavigationBar
        navigationController.pushViewController(controller, animated: animated)
    }
}
