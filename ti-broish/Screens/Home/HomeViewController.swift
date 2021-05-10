//
//  HomeViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/6/21.
//  
//

import UIKit
import Firebase

final class HomeViewController: BaseViewController {
    
    let viewModel = HomeViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIClient().getCountries(isAbroad: true) { response in
            switch response {
            case .success(let countries):
                print("getCountries.success: \(countries)")
            case .failure(let error):
                print("getCountries.failure: \(error)")
            }
        }
    }
    
    override func applyTheme() {
        super.applyTheme()
    }
}
