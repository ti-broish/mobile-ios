//
//  ExampleViewController.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 22.04.21.
//

import UIKit

protocol ExampleViewModelProtocol: CoordinatableViewModel {
    
}

class ExampleViewController: BaseViewController {

    // MARK: - Properites
    
    private var viewModel: ExampleViewModelProtocol! {
        didSet {
            viewModel.start()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - Scene Factory
extension ExampleViewController {
    
    static func create(delegate: ExampleSceneDelegate) -> BaseViewController {
        let controller = ExampleViewController()
        controller.viewModel = ExampleViewModel(delegate: delegate)
        return controller
    }
    
}
