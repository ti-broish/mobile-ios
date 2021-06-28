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
        webView.navigationDelegate = self
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        navigationItem.configureTitleView()
    }
    
    private func observeReloadDataPublisher() {
        reloadDataSubscription = viewModel
            .reloadDataPublisher
            .sink(
                receiveCompletion: { [unowned self] _ in 
                    webView.loadHTMLString(viewModel.htmlString ?? "", baseURL: nil)
                },
                receiveValue: { [unowned self] error in
                    if let error = error {
                        print("reload data failed \(error)")
                        view.hideLoading()
                    } else {
                        webView.loadHTMLString(viewModel.htmlString ?? "", baseURL: nil)
                    }
                })
    }
    
    private func observeLoadingPublisher() {
        loadingSubscription = viewModel.loadingPublisher.sink(receiveValue: { [unowned self] isLoading in
            isLoading ? view.showLoading() : view.hideLoading()
        })
    }
    
    private func addObservers() {
        observeReloadDataPublisher()
        observeLoadingPublisher()
    }
}

// MARK: - WKNavigationDelegate

extension TermsViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideLoading()
    }
}
