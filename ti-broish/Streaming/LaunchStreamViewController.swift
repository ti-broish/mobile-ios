//
//  LaunchStreamViewController.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 27.03.21.
//

import UIKit

class LaunchStreamController: StreamingBaseViewController {
    
    static let storyboardId = "LaunchStream"
    
    static func instantiate() -> LaunchStreamController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Streaming", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: LaunchStreamController.storyboardId) as! LaunchStreamController
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var backgroundView: UIImageView!
    
    private var launchedStream = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!launchedStream) {
            fetchStream()
        } else {
            navigationController?.popViewController(animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.stopAnimating()
    }
    
    @IBAction func onTryAgainClick(_ sender: Any) {
        fetchStream()
    }
    
    private func initViews() {
        loadingLabel.text = .localized("stream_message_loading")
        loadingLabel.text = .localized("label_loading")
        tryAgainButton.configureSolidButton(title: .localized("button_try_again"), theme: theme)
    }
    
    private func hideLoading() {
        loadingLabel.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showLoading() {
        loadingLabel.isHidden = false
        tryAgainButton.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func fetchStream() {
        showLoading()
        #warning("Fetch the actual streaming info")
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
            UserStreamingSession.default.streamInfo = UserStream(streamUrl: "rtmp://strm.ludost.net/st/streamtest", viewUrl: "https://strm.ludost.net/hls/streamtest.m3u8")
            self?.hideLoading()
            self?.launchedStream = true
            self?.performSegue(withIdentifier: "StartStreaming", sender: nil)
        })
        
        #warning("Use error handling when the fetch streaming info is implemented")
        //            switch (error) {
        //                case .noInternet:
        //                    self?.messageLabel.text = .localized("launch_stream_error_no_internet")
        //                    self?.backgroundView.image = UIImage(named: "BackgroundWarn")?.withRenderingMode(.alwaysOriginal)
        //                case .streamingNotAllowed:
        //                    self?.messageLabel.text = .localized("launch_stream_error_stream_unavailable")
        //                    self?.backgroundView.image = UIImage(named: "BackgroundClock")?.withRenderingMode(.alwaysOriginal)
        //                default:
        //                    self?.messageLabel.text = .localized("launch_stream_error_generic")
        //                    self?.backgroundView.image = UIImage(named: "BackgroundWarn")?.withRenderingMode(.alwaysOriginal)
        //            }
        //            self?.hideLoading()
        //            self?.tryAgainButton.isHidden = false
        //        })
    }
}
