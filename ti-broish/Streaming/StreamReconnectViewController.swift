//
//  StreamLostConnectionViewController.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 29.03.21.
//

import UIKit

protocol StreamReconnectControllerDelegate {
    func onTryAgainClick()
    func onExitClick()
}

enum ReconnectReason {
    case noInternet
    case streamInterrupted
}

class StreamReconnectViewController: StreamingBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    var delegate: StreamReconnectControllerDelegate? = nil
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingState()
        }
    }
    
    var reason: ReconnectReason = .streamInterrupted {
        didSet {
            updateTitle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        updateLoadingState()
        
        updateTitle()
        loadingLabel.text = .localized("label_loading")
        tryAgainButton.configureSolidButton(title: .localized("button_try_again"), theme: theme)
        exitButton.configureSolidButton(title: .localized("button_exit"), theme: theme)
    }
    
    @IBAction func onTryAgainClick(_ sender: Any) {
        delegate?.onTryAgainClick()
    }
    
    @IBAction func onExitClick(_ sender: Any) {
        delegate?.onExitClick()
    }
    
    private func updateLoadingState() {
        if (isLoading) {
            loadingLabel?.isHidden = false
            activityIndicator?.startAnimating()
            tryAgainButton?.isHidden = true
        } else {
            loadingLabel?.isHidden = true
            activityIndicator?.stopAnimating()
            tryAgainButton?.isHidden = false
        }
    }
    
    private func updateTitle() {
        switch (reason) {
            case .noInternet:
                titleLabel?.text = .localized("stream_message_no_internet_connection_try_again")
            case .streamInterrupted:
                titleLabel?.text = .localized("stream_message_stream_disrupted")
        }
    }
}
