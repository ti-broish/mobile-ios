//
//  TermsViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 23.04.21.
//

import UIKit
import WebKit
import Combine

final class TermsViewController: BaseViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    private let viewModel = TermsViewModel()

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        viewModel.start()
    }
    
    override func applyTheme() {
        super.applyTheme()
        
        webView.backgroundColor = .clear
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureTitleView()
    }
    
    private func addObservers() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { error in
                    print("reload data failed \(error)")
                },
                receiveValue: { [unowned self] _ in
                    webView.loadHTMLString(viewModel.htmlString ?? "", baseURL: nil)
                })
    }
}
