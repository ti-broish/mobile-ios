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
    @IBOutlet private weak var checkinButton: UIButton!
    
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
        
        liveButton.configureSolidButton(
            attributedTitle: LocalizedStrings.Menu.live.makeLiveText(textColor: theme.solidButtonTextColor),
            theme: theme
        )
        
        checkinButton.configureSolidButton(title: LocalizedStrings.Menu.checkin, theme: theme)
        checkinButton.isHidden = !LocalStorage.User().isLoggedIn
        termsButton.configureSolidButton(title: LocalizedStrings.Home.terms, theme: theme)
        
        #if STAGING
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "STAGING_ENVIRONMENT"
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 14.0)
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -64.0)
        ])
        #endif
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
    
    @IBAction private func handleCheckinButton(_ sender: UIButton) {
        viewModel.coordinator?.loadViewController(nibName: CheckinViewController.nibName)
    }
}
