//
//  ExampleViewController.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 22.04.21.
//

import UIKit
import SFBaseKit

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

// MARK: - StoryboardInstantiatable
extension ExampleViewController: StoryboardInstantiatable {
    
    static var storyboardName: String {
        "Example"
    }
    
    static func create(delegate: ExampleSceneDelegate) -> BaseViewController {
        guard let controller = Self.instantiateFromStoryboard() else { return BaseViewController() }
        controller.viewModel = ExampleViewModel(delegate: delegate)
        return controller
    }
    
}
