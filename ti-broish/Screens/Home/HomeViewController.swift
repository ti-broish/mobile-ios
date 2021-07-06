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
    
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var sendProtocolButton: UIButton!
    @IBOutlet private weak var sendViolationButton: UIButton!
    @IBOutlet private weak var termsButton: UIButton!
    @IBOutlet private weak var liveButton: UIButton!
    
    let viewModel = HomeViewModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func applyTheme() {
        super.applyTheme()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        let theme = TibTheme()
        sendProtocolButton.configureSolidButton(title: LocalizedStrings.Home.sendProtocol, theme: theme)
        sendViolationButton.configureSolidButton(title: LocalizedStrings.Home.sendViolation, theme: theme)
        termsButton.configureSolidButton(title: LocalizedStrings.Home.terms, theme: theme)
        // TODO: - make attributed string
        liveButton.configureSolidButton(attributedTitle: LocalizedStrings.Menu.live.makeLiveText(), theme: theme)
    }
    
    @IBAction private func handleSendProtocolButton(_ sender: UIButton) {
        viewModel.coordinator?.loadViewController(nibName: SendProtocolViewController.nibName)
    }
    
    @IBAction private func handleSendViolationButton(_ sender: UIButton) {
        viewModel.coordinator?.loadViewController(nibName: SendViolationViewController.nibName)
    }
    
    @IBAction private func handleTermsButton(_ sender: UIButton) {
        viewModel.coordinator?.loadViewController(nibName: TermsViewController.nibName)
    }
    
    @IBAction private func handleLiveButton(_ sender: UIButton) {
        viewModel.coordinator?.loadViewController(nibName: StartStreamViewController.nibName)
    }
}
