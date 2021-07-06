//
//  StreamLostConnectionViewController.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 29.03.21.
//

import UIKit

protocol StreamReconnectControllerDelegate {
    func onTryAgainClick()
    func onCancelClick()
}

enum ReconnectReason {
    case noInternet
    case streamInterrupted
    case connectionError
}

class StreamReconnectViewController: StreamingBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        cancelButton.configureSolidButton(title: .localized("button_cancel"), theme: theme)
    }
    
    @IBAction func onTryAgainClick(_ sender: Any) {
        delegate?.onTryAgainClick()
        isLoading = true
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        delegate?.onCancelClick()
        dismiss(animated: true, completion: nil)
    }
    
    private func updateLoadingState() {
        if (isLoading) {
            loadingLabel?.isHidden = false
            activityIndicator?.isHidden = false
            activityIndicator?.startAnimating()
            tryAgainButton?.isHidden = true
            cancelButton?.configureSolidButton(title: .localized("button_cancel"), theme: theme)
        } else {
            loadingLabel?.isHidden = true
            activityIndicator?.stopAnimating()
            activityIndicator?.isHidden = true
            tryAgainButton?.isHidden = false
            cancelButton?.configureSolidButton(title: .localized("button_close"), theme: theme)
        }
    }
    
    private func updateTitle() {
        switch (reason) {
            case .noInternet:
                titleLabel?.text = .localized("stream_message_no_internet_connection_try_again")
            case .streamInterrupted:
                titleLabel?.text = .localized("stream_message_stream_disrupted")
            case .connectionError:
                titleLabel?.text = .localized("stream_message_stream_cannot_connect")
        }
    }
}
