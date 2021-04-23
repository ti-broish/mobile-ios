//
//  ExampleCoordinator.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 22.04.21.
//

import UIKit
import SFBaseKit

class ExampleCoordinator: Coordinator {
    
    // MARK: - Properties
    var rootViewController: UINavigationController?
    
    // MARK: - Coordinator
    
    init(navigationController: UINavigationController) {
        super.init()
        // Initially you'd like to attach your coordinator's flow to already existing one.
        // 90% of the cases it would be a navigation controller. You should pass it as dependency.
        
        // **NOTE**
        // The coordinator's main work is to manage flow, it should be aware of how the flow
        // should work and how it's boarded. If the initial scene is supposed to be presented this
        // init should take UIViewController instead and set the root to it. Then start (board) the
        // initial screen of the flow by calling present on the root.
        
        // **IMPORTANT**
        // Don't give full freedom to something that is supposed to work in a particular way. There may be
        // cases where you'd like to be able to present and push a coordinated flow, but if that is not the case
        // DO NOT design the coordinator in a way you're never supposed to use.
        rootViewController = navigationController
    }
    
    override func start() {
        // Start the next coordinator in the heirarchy or the current module rootViewModel
        let viewController = ExampleViewController.create(delegate: self)
        rootViewController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ExampleSceneDelegate
extension ExampleCoordinator: ExampleSceneDelegate {
    
}
