//
//  BaseViewController.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 25.04.21.
//

import UIKit
import Combine

class BaseViewController: UIViewController, TibViewControllable {
    
    var reloadDataSubscription: AnyCancellable?
    var loadingSubscription: AnyCancellable?

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
    func applyTheme() {
        let theme = TibTheme()
        self.view.backgroundColor = theme.backgroundColor
    }
}
