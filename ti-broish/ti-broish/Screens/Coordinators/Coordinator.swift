//
//  Coordinator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/23/21.
//  
//

import UIKit

protocol Coordinator: class {
    
    var navigationController: UINavigationController { get set }
    
    func start()
}
