//
//  ContentContainerViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/12/21.
//  
//

import UIKit

final class ContentContainerViewController: BaseViewController {
    
    private var contentViewController = UIViewController()
    private var currentViewController: UIViewController?
    private var menuViewController: MenuViewController!
    private var isMenuExpand: Bool = true

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        setupContentViewController()
        setupMenuViewController()
        setupNavigationBar()
    }
    
    // MARK: - Private methods
    
    private func removeCurrentViewController() {
        guard let _currentViewController = currentViewController, _currentViewController.isViewLoaded else {
            return
        }
        
        _currentViewController.willMove(toParent: nil)
        _currentViewController.view.removeFromSuperview()
        _currentViewController.removeFromParent()
    }
    
    private func loadViewController(nibName: String) {
        removeCurrentViewController()
        toggleMainMenu()
        
        switch nibName {
        case HomeViewController.nibName:
            currentViewController = HomeViewController.init(nibName: nibName, bundle: nil)
        case ProfileViewController.nibName:
            currentViewController = ProfileViewController.init(nibName: nibName, bundle: nil)
        case SendProtocolViewController.nibName:
            currentViewController = SendProtocolViewController.init(nibName: nibName, bundle: nil)
        case SendViolationViewController.nibName:
            currentViewController = SendViolationViewController.init(nibName: nibName, bundle: nil)
        case ProtocolsTableViewController.nibName:
            currentViewController = ProtocolsTableViewController.init(nibName: nibName, bundle: nil)
        case ViolationsTableViewController.nibName:
            currentViewController = ViolationsTableViewController.init(nibName: nibName, bundle: nil)
        case TermsViewController.nibName:
            currentViewController = TermsViewController.init(nibName: nibName, bundle: nil)
        default:
            assertionFailure("Invalid or not handled nibName")
            break
        }
        
        if let _currentViewController = currentViewController {
            contentViewController.view.addSubview(_currentViewController.view)
            _currentViewController.view.frame = contentViewController.view.bounds
            _currentViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentViewController.addChild(_currentViewController)
            _currentViewController.didMove(toParent: contentViewController)
        }
    }
    
    private func setupContentViewController() {
        loadViewController(nibName: HomeViewController.nibName)
        view.addSubview(contentViewController.view)
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
    }
    
    private func setupMenuViewController() {
        guard menuViewController == nil else {
            return
        }
        
        menuViewController = MenuViewController.init(nibName: MenuViewController.nibName, bundle: nil)
        menuViewController.delegate = self
        view.insertSubview(menuViewController.view, at: 0)
        menuViewController.view.frame = contentViewController.view.bounds
        menuViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addChild(menuViewController)
        menuViewController.didMove(toParent: self)
    }
    
    @objc private func toggleMainMenu() {
        if !isMenuExpand {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.contentViewController.view.frame.origin.x = self.contentViewController.view.frame.width * 0.75
                }, completion: { _ in
                    self.isMenuExpand = true
                })
        } else {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.contentViewController.view.frame.origin.x = 0.0
                }, completion: { _ in
                    self.isMenuExpand = false
                })
        }
    }
    
    private func setupNavigationBar() {
        let menuButton = UIBarButtonItem(
            title: LocalizedStrings.menu,
            style: .plain,
            target: self,
            action: #selector(toggleMainMenu)
        )
        
        navigationItem.setLeftBarButton(menuButton, animated: true)
    }
}

// MARK: - MenuViewControllerDelegate

extension ContentContainerViewController: MenuViewControllerDelegate {
    
    func didSelectMenuItem(_ menuItem: MenuItem, sender: MenuViewController) {
        switch menuItem.type {
//        case .home:
//            loadViewController(nibName: HomeViewController.nibName)
        case .profile:
            loadViewController(nibName: ProfileViewController.nibName)
        case .sendProtocol:
            loadViewController(nibName: SendProtocolViewController.nibName)
        case .sendViolation:
            loadViewController(nibName: SendViolationViewController.nibName)
        case .protocols:
            loadViewController(nibName: ProtocolsTableViewController.nibName)
        case .violations:
            loadViewController(nibName: ViolationsTableViewController.nibName)
        case .terms:
            loadViewController(nibName: TermsViewController.nibName)
        case .live:
            // TODO: - implement
            break
        case .logout:
            coordinator?.showLoginScreen()
        }
    }
}
