//
//  BaseViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit

class BaseViewController: UIViewController, TibViewControllable {
    
    let theme = TibTheme()
    weak var coordinator: ScreenCoordinator?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
    func applyTheme() {
        self.view.backgroundColor = theme.backgroundColor
    }
}
