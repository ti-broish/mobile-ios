//
//  ContentContainerViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/12/21.
//  
//

import UIKit
import Firebase

final class ContentContainerViewController: BaseViewController {
    
    private var contentViewController = UIViewController()
    private var currentViewController: UIViewController?
    private var menuViewController: MenuViewController!
    
    private var isMenuExpand: Bool = true {
        didSet {
            menuViewController.reloadData()
        }
    }
    
    weak var coordinator: ContentContainerCoordinator?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.configureBackButton()
        self.navigationItem.configureTitleView()
        
        setupContentViewController()
        setupMenuViewController()
        setupNavigationBar()
        addObservers()
    }
    
    func showRemoteNotificationViewController(nibName: String) {
        coordinator?.remove(currentViewController)
        
        if let viewController = coordinator?.getViewController(nibName: nibName) {
            currentViewController = viewController
            coordinator?.add(viewController: viewController, to: contentViewController)
        }
    }
    
    // MARK: - Private methods
    
    private func removeCurrentViewController() {
        guard let currentViewController = currentViewController, currentViewController.parent != nil else {
            return
        }
        
        currentViewController.willMove(toParent: nil)
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParent()
    }
    
    private func loadViewController(nibName: String) {
        coordinator?.remove(currentViewController)
        toggleMainMenu()
        
        if let viewController = coordinator?.getViewController(nibName: nibName) {
            currentViewController = viewController
            coordinator?.add(viewController: viewController, to: contentViewController)
        }
    }
    
    private func loadLoginViewController() {
        toggleMainMenu()
        
        guard let loginViewController = coordinator?.getViewController(nibName: LoginViewController.nibName) as? LoginViewController else {
            return
        }

        let navController = UINavigationController(rootViewController: loginViewController)
        navController.navigationBar.isHidden = true
        navController.navigationBar.tintColor = navigationController!.navigationBar.tintColor
        navController.navigationBar.standardAppearance = navigationController!.navigationBar.standardAppearance
        navController.navigationBar.scrollEdgeAppearance = navigationController!.navigationBar.scrollEdgeAppearance
        loginViewController.viewModel.coordinator = LoginCoordinator(navigationController: navController)
        
        self.present(navController, animated: true)
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
            title: LocalizedStrings.Buttons.menu,
            style: .plain,
            target: self,
            action: #selector(toggleMainMenu)
        )
        
        menuButton.setTitleTextAttributes([.font: UIFont.semiBoldFont(size: 17.0)], for: .normal)
        navigationItem.setLeftBarButton(menuButton, animated: true)
    }
    
    private func signOut() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        do {
            try Auth.auth().signOut()
            LocalStorage.User().reset()
            LocalStorage.AppCheck().reset()
            CheckinUtils().reset()
            toggleMainMenu()
            appDelegate.appCoordinator?.start()
        } catch {
            print("signOut failed: \(error)")
        }
    }
    
    @objc private func handleForceLogoutNotification(_ notification: Notification) {
        signOut()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleForceLogoutNotification),
            name: Notification.Name.forceLogout,
            object: nil
        )
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
        case .live:
            loadViewController(nibName: StartStreamViewController.nibName)
        case .checkin:
            loadViewController(nibName: CheckinViewController.nibName)
        case .protocols:
            loadViewController(nibName: ProtocolsTableViewController.nibName)
        case .violations:
            loadViewController(nibName: ViolationsTableViewController.nibName)
        case .terms:
            loadViewController(nibName: TermsViewController.nibName)
        case .logout:
            signOut()
        case .login:
            loadLoginViewController()
        }
    }
}
