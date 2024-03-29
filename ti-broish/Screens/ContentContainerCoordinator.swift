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
    
    func showProtocol(id: String) {
        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
        viewController.viewModel.protocolId = id

        pushController(viewController, animated: true)
    }
    
    func showViolation(id: String) {
        let viewController = DetailsViewController.init(nibName: DetailsViewController.nibName, bundle: nil)
        viewController.viewModel.violationId = id

        pushController(viewController, animated: true)
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
            let viewController = HomeViewController.init(nibName: nibName, bundle: nil)
            viewController.viewModel.coordinator = homeCoordinator
            
            return viewController
        case ProfileViewController.nibName:
            let viewController = ProfileViewController.init(nibName: nibName, bundle: nil)
            viewController.coordinator = self
            
            return viewController
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
        case CheckinViewController.nibName:
            return CheckinViewController.init(nibName: nibName, bundle: nil)
        case LoginViewController.nibName:
            return LoginViewController.init(nibName: nibName, bundle: nil)
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

