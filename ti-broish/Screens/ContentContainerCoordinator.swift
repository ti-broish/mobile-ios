//
//  ContentContainerCoordinator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.06.21.
//

import UIKit

final class ContentContainerCoordinator: Coordinator {
    
    private var homeCoordinator: HomeCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController        
        homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
    }
    
    override func start() {
        showHomeScreen()
    }
    
    func showHomeScreen() {
        let controller = ContentContainerViewController()
        controller.coordinator = self
        
        navigationController.viewControllers.removeAll()
        pushController(controller, animated: false)
    }
    
    func remove(_ viewController: UIViewController?) {
        guard let controller = viewController, controller.parent != nil else {
            return
        }
        
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    func add(viewController: UIViewController?, to parentViewController: UIViewController) {
        if let childViewController = viewController {
            parentViewController.addChild(childViewController)
            parentViewController.view.addSubview(childViewController.view)
            childViewController.view.frame = parentViewController.view.bounds
            childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            childViewController.didMove(toParent: parentViewController)
        }
    }
    
    func getViewController(nibName: String) -> UIViewController? {
        switch nibName {
        case HomeViewController.nibName:
            let controller = HomeViewController.init(nibName: nibName, bundle: nil)
            controller.viewModel.coordinator = homeCoordinator
            
            return controller
        case ProfileViewController.nibName:
            return ProfileViewController.init(nibName: nibName, bundle: nil)
        case SendProtocolViewController.nibName:
            return SendProtocolViewController.init(nibName: nibName, bundle: nil)
        case SendViolationViewController.nibName:
            return SendViolationViewController.init(nibName: nibName, bundle: nil)
        case ProtocolsTableViewController.nibName:
            return ProtocolsTableViewController.init(nibName: nibName, bundle: nil)
        case ViolationsTableViewController.nibName:
            return ViolationsTableViewController.init(nibName: nibName, bundle: nil)
        case TermsViewController.nibName:
            return TermsViewController.init(nibName: nibName, bundle: nil)
        case StartStreamViewController.nibName:
            return StartStreamViewController.init(nibName: nibName, bundle: nil)
        default:
            assertionFailure("Invalid or not handled nibName")
            return nil
        }
    }
    
    // MARK: - Private methods
    
    private func pushController(_ controller: UIViewController, hideNavigationBar: Bool = false, animated: Bool = true) {
        navigationController.navigationBar.isHidden = hideNavigationBar
        navigationController.pushViewController(controller, animated: animated)
    }
}

