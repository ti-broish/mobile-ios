//
//  ExampleViewModel.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 23.04.21.
//

import Foundation

protocol ExampleSceneDelegate: Coordinator {
    
}

class ExampleViewModel: ExampleViewModelProtocol {
    
    // MARK: - Properties
    unowned let delegate: ExampleSceneDelegate
    
    // MARK: - Initializers
    
    init(delegate: ExampleSceneDelegate) {
        self.delegate = delegate
    }
    
}
