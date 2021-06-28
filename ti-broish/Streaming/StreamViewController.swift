//
//  ViewController.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 25.03.21.
//

import UIKit

import ReplayKit
import HaishinKit
import CoreMotion
import Network
import SystemConfiguration
import CoreTelephony
import FirebaseAuth

class StreamViewController: StreamingBaseViewController, StreamReconnectControllerDelegate {
    
    // Views
    @IBOutlet weak var cameraFeedView: HKView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var moreMenuButton: UIButton!
    @IBOutlet weak var flashlightButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    
    // Permissions
    @IBOutlet weak var permissionsDeniedMessage: UILabel!
    @IBOutlet weak var givePermissionsButton: UIButton!
    
    // Rotation
    private var motionManager: CMMotionManager?
    private var timer: Timer?
    
    // Stream
    private var isStreamStarted = false
    private var reattachStreamOnBecomeActive = false
    private var rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var connectionUrl = ""
    private var streamName = ""
    private var videoQuality: VideoStreamQuality = .lowQuality
    private var videoOrientation: VideoStreamOrientation = .portrait
    
    // Timer
    private var currentStreamTimer: Timer?
    private var currentStreamDurationSeconds: Int = 0
    
    // Flashlight
    private var isFlashlightOn = false
    
    // Instructions
    private var hasShownInstructions = false
    
    // Network & Reconnect
    private var networkMonitor = NWPathMonitor()
    private var reconnectDialogVc: StreamReconnectViewController?
    private var reconnectionWorkItem: DispatchWorkItem? = nil
    private var networkMonitorQueue = DispatchQueue(label: "Network monitor")
    private var reconnectQueue = DispatchQueue(label: "Reconnect Stream")
    
    private var streamConnectRetryCount = 0
    private let streamConnectRetryMax = 5
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionUrl = UserStreamingSession.default.streamInfo?.streamConnectionUrl ?? ""
        streamName = UserStreamingSession.default.streamInfo?.streamName ?? ""
        
        reconnectionWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else {return}
            if (!strongSelf.rtmpConnection.connected) {
                strongSelf.rtmpConnection.connect(strongSelf.connectionUrl)
                strongSelf.streamConnectRetryCount += 1
            }
        }
        rtmpStream = RTMPStream(connection: rtmpConnection)
        initViews()
        startDeviceMotionService()
        startNetworkMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissionsAndInitStream()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!hasShownInstructions) {
            hasShownInstructions = true
            performSegue(withIdentifier: "ShowInstructions", sender: nil)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitStreaming()
    }
    
    
    @objc func didEnterBackground(_ notification: Notification) {
        cameraFeedView.attachStream(nil)
        reattachStreamOnBecomeActive = true
        if (isStreamStarted) {
            stopStreaming()
        }
    }
    
    @objc func didBecomeActive(_ notification: Notification) {
        if (reattachStreamOnBecomeActive) {
            cameraFeedView.attachStream(rtmpStream)
            reattachStreamOnBecomeActive = false
        }
    }
    
    deinit {
        stopMotionUpdates()
        networkMonitor.cancel()
    }
    
    @IBAction func startStopTapped(_ sender: Any) {
        if (isStreamStarted) {
            stopStreaming()
        } else {
            startStreaming()
        }
    }
    
    @IBAction func onFlashlightClick(_ sender: Any) {
        isFlashlightOn = !isFlashlightOn
        rtmpStream.torch = isFlashlightOn
        if (isFlashlightOn) {
            flashlightButton.setImage(.flashlightTurnOff, for: .normal)
        } else {
            flashlightButton.setImage(.flashlightTurnOn, for: .normal)
        }
    }
    
    @IBAction func onMoreMenuClick(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: .localized("button_close"), style: .cancel, handler: nil)
        actionSheetController.addAction(cancelActionButton)
        
        let exitActionButton = UIAlertAction(title: .localized("button_exit"), style: .destructive) { [weak self] _ in
            self?.confirmExit()
        }
        
        if let shareUrl = URL(string: UserStreamingSession.default.streamInfo?.viewUrl ?? "") {
            let shareActionButton = UIAlertAction(title: .localized("button_share_stream"), style: .default) { [weak self] _ in
                self?.share(title: .localized("stream_share_title"), url: shareUrl)
            }
            actionSheetController.addAction(shareActionButton)
        }
        actionSheetController.addAction(exitActionButton)
        
        actionSheetController.popoverPresentationController?.sourceView = moreMenuButton
        actionSheetController.popoverPresentationController?.sourceRect = moreMenuButton.bounds
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    private func initViews() {
        givePermissionsButton.configureSolidButton(title: .localized("button_allow"), theme: theme)
        
        permissionsDeniedMessage.text = .localized("stream_permissions_text")
        liveLabel.text = .localized("stream_live_label")
    }
    
    
    private func exitStreaming() {
        if (isStreamStarted) {
            stopStreaming()
        }
        
        dismissToRoot(animated: true, completion: nil)
    }
    
    private func confirmExit() {
        let alertController: UIAlertController = UIAlertController(title: .localized("confirm_exit_title"), message: .localized("confirm_exit_message"), preferredStyle: .alert)
        
        let cancelActionButton = UIAlertAction(title: .localized("button_no"), style: .cancel, handler: nil)
        alertController.addAction(cancelActionButton)
        
        let exitActionButton = UIAlertAction(title: .localized("button_yes"), style: .destructive) { [weak self] _ in
            self?.exitStreaming()
        }
        alertController.addAction(exitActionButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func share(title:String, url: URL) {
        let sharedObjects:[AnyObject] = [title as AnyObject, url as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Permissions
    
    private func checkPermissionsAndInitStream() {
        CaptureDevice.checkPermissions(for: [.audio, .video], required: [.audio, .video], completion: { [weak self] granted, permissions in
            if (granted) {
                self?.hidePermissionsDenied()
                self?.initStream()
            } else {
                self?.showPermissionsDenied()
            }
        })
    }
    
    private func showPermissionsDenied() {
        cameraFeedView.isHidden = true
        flashlightButton.isEnabled = false
        permissionsDeniedMessage.isHidden = false
        givePermissionsButton.isHidden = false
    }
    
    private func hidePermissionsDenied() {
        cameraFeedView.isHidden = false
        permissionsDeniedMessage.isHidden = true
        givePermissionsButton.isHidden = true
    }
    
    @IBAction func onGivePermissionsClick(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    // MARK: - Streaming
    
    private func initStream() {
        initRtmpStream()
        startStopButton.isEnabled = true
        flashlightButton.isEnabled = true
    }
    
    private func deinitStreaming() {
        isFlashlightOn = false
        rtmpStream?.close()
        rtmpStream?.dispose()
    }
    
    private func initRtmpStream() {
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            print(error)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print(error)
        }
        rtmpStream.audioSettings = .default
        
        rtmpStream.captureSettings = videoQuality.captureSettings
        
        cameraFeedView.translatesAutoresizingMaskIntoConstraints = true
        cameraFeedView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraFeedView.attachStream(rtmpStream)
    }
    
    private func startStreaming() {
        startStopButton.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = true
        rtmpConnection.connect(connectionUrl)
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        isStreamStarted = true
    }
    
    private func stopStreaming() {
        startStopButton.isEnabled = false
        UIApplication.shared.isIdleTimerDisabled = false
        rtmpConnection.close()
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        isStreamStarted = false
        onStreamStopped()
    }
    
    private func onStreamStarted() {
        startStopButton.setImage(.stopButton, for: .normal)
        startStopButton.isEnabled = true
        startTimer()
        liveLabel.isHidden = false
    }
    
    private func onStreamInterrupted() {
        startStopButton.setImage(.startButton, for: .normal)
        startStopButton.isEnabled = true
        stopTimer()
        liveLabel.isHidden = true
    }
    
    private func onStreamStopped() {
        startStopButton.setImage(.startButton, for: .normal)
        startStopButton.isEnabled = true
        stopTimer()
        liveLabel.isHidden = true
    }
    
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        switch (code) {
            case RTMPConnection.Code.connectSuccess.rawValue:
                streamConnectRetryCount = 0
                DispatchQueue.main.async {
                    self.rtmpStream?.publish(self.streamName)
                    if (self.reconnectDialogVc != nil) {
                        self.hideReconnectDialog()
                    }
                    self.onStreamStarted()
                }
            case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
                if (streamConnectRetryCount <= streamConnectRetryMax) {
                    DispatchQueue.main.async {
                        self.showReconnectDialog(reason: .streamInterrupted)
                        self.reconnectDialogVc?.isLoading = true
                        self.onStreamInterrupted()
                    }
                    
                    if let reconnectWork = reconnectionWorkItem {
                        reconnectQueue.asyncAfter(deadline: .now() + pow(2.0, Double(streamConnectRetryCount)), execute: reconnectWork)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.reconnectDialogVc?.isLoading = false
                        self.onStreamInterrupted()
                    }
                }
            default:
                break
        }
    }
    
    @objc private func rtmpErrorHandler(_ notification: Notification) {
        rtmpConnection.connect(connectionUrl)
    }
    
    //MARK: - Orientation Change
    func deviceOrientationChanged(to: UIInterfaceOrientation) {
        switch to {
            case .landscapeLeft:
                rotateViews(rotationRadians: 1.5708) // 90 degrees
                rtmpStream.orientation = .landscapeRight
                updateVideoStreamSettings(orientation: .landscape)
            case .landscapeRight:
                rotateViews(rotationRadians: 4.7123) // 270 degrees
                rtmpStream.orientation = .landscapeLeft
                updateVideoStreamSettings(orientation: .landscape)
            case .portraitUpsideDown:
                // unreachable because of the current implementation of rotation detection
                rotateViews(rotationRadians: 3.1415) // 180 degrees
                rtmpStream.orientation = .portraitUpsideDown
                updateVideoStreamSettings(orientation: .portrait)
            case .portrait:
                fallthrough
            default:
                rotateViews(rotationRadians: 0)
                rtmpStream?.orientation = .portrait
                updateVideoStreamSettings(orientation: .portrait)
        }
        // reset the camera connection orientation to portrait as we handle the rotation manually
        cameraFeedView.layer.connection?.videoOrientation = .portrait
    }
    
    private func rotateViews(rotationRadians: CGFloat) {
        startStopButton.setRotation(radians: rotationRadians)
        moreMenuButton.setRotation(radians: rotationRadians)
        flashlightButton.setRotation(radians: rotationRadians)
        timerLabel.setRotation(radians: rotationRadians)
        liveLabel.setRotation(radians: rotationRadians)
    }
    
    private func updateVideoStreamSettings(quality: VideoStreamQuality? = nil, orientation: VideoStreamOrientation? = nil) {
        if let newQuality = quality {
            videoQuality = newQuality
        }
        if let newOrientation = orientation {
            videoOrientation = newOrientation
        }
        rtmpStream?.videoSettings = .settings(for: videoQuality, orientation: videoOrientation)
        rtmpStream?.captureSettings = videoQuality.captureSettings
    }
    
    // MARK: - Network Connection
    
    private func startNetworkMonitoring() {
        networkMonitor = NWPathMonitor()
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.onNetworkConnectionChanged(isConnected: path.status == .satisfied, bestNetworkInterface: path.availableInterfaces.first)
        }
        networkMonitor.start(queue: networkMonitorQueue)
    }
    
    private func onNetworkConnectionChanged(isConnected: Bool, bestNetworkInterface: NWInterface?) {
        if (!isConnected) {
            DispatchQueue.main.async {
                if(self.isStreamStarted) {
                    self.showReconnectDialog(reason: .streamInterrupted)
                    self.reconnectDialogVc?.isLoading = true
                } else {
                    self.showReconnectDialog(reason: .noInternet)
                    self.reconnectDialogVc?.isLoading = false
                }
            }
        } else {
            if let networkInterface = bestNetworkInterface {
                if networkInterface.type == .wifi {
                    updateVideoStreamSettings(quality: .highQuality)
                } else {
                    updateVideoQualityFromConnectivity()
                }
            }
            
            DispatchQueue.main.async {
                if (self.reconnectDialogVc?.reason == .noInternet) {
                    if (self.isStreamStarted) {
                        self.retryConnection()
                    } else {
                        self.hideReconnectDialog()
                    }
                }
            }
        }
    }
    
    
    // MARK: - Reconnect
    private func retryConnection() {
        streamConnectRetryCount = 0
        reconnectionWorkItem?.cancel()
        rtmpConnection.connect(connectionUrl)
    }
    
    func onTryAgainClick() {
        if (isStreamStarted){
            retryConnection()
        } else {
            networkMonitor.cancel()
            startNetworkMonitoring()
        }
    }
    
    func onExitClick() {
        exitStreaming()
    }
    
    private func showReconnectDialog(reason: ReconnectReason) {
        guard reconnectDialogVc == nil else {
            return
        }
        let storyboard = UIStoryboard(name: "Streaming", bundle: nil)
        let reconnectDialogVc = storyboard.instantiateViewController(identifier: "StreamLostConnection") as StreamReconnectViewController
        reconnectDialogVc.modalPresentationStyle = .overFullScreen
        reconnectDialogVc.modalTransitionStyle = .crossDissolve
        reconnectDialogVc.delegate = self
        reconnectDialogVc.reason = reason
        reconnectDialogVc.popoverPresentationController?.sourceView = startStopButton
        reconnectDialogVc.popoverPresentationController?.sourceRect = startStopButton.bounds
        
        present(reconnectDialogVc, animated: true, completion: nil)
        self.reconnectDialogVc = reconnectDialogVc
    }
    
    private func hideReconnectDialog() {
        if (reconnectDialogVc != nil) {
            reconnectDialogVc?.dismiss(animated: true, completion: nil)
            reconnectDialogVc = nil
        }
    }
    
    private func updateVideoQualityFromConnectivity() {
        let connectivity = checkConnectivity(toUrl: connectionUrl)
        switch (connectivity) {
            case .cellular2g:
                updateVideoStreamSettings(quality: .lowQuality)
            case .cellular3g:
                updateVideoStreamSettings(quality: .mediumQuality)
            case .cellular4g:
                updateVideoStreamSettings(quality: .highQuality)
            case .wifi:
                updateVideoStreamSettings(quality: .highQuality)
            default:
                updateVideoStreamSettings(quality: .lowQuality)
        }
    }
    
    //MARK: - Timer
    
    private func startTimer() {
        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.currentStreamDurationSeconds += 1
            self?.updateTimerLabel()
        }
        
        RunLoop.main.add(timer, forMode: .common)
        
        currentStreamTimer?.invalidate()
        currentStreamTimer = timer
    }
    
    private func stopTimer() {
        currentStreamTimer?.invalidate()
        currentStreamTimer = nil
        currentStreamDurationSeconds = 0
        updateTimerLabel()
    }
    
    private func updateTimerLabel() {
        let inMinutes = currentStreamDurationSeconds / 60
        let hours = inMinutes / 60
        
        let seconds = currentStreamDurationSeconds % 60
        let minutes = inMinutes % 60
        
        timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - Device Rotation
// https://medium.com/@yurrrov/detecting-and-handling-ios-device-orientation-without-kvo-ef26ae13a615
extension StreamViewController {
    
    private func startDeviceMotionService() {
        // At first, we need to create Motion Manager object.
        // It is responsible for all the CoreMotion instruments
        motionManager = CMMotionManager()
        // If we successfully created motionManager, we check if
        // device have both accelerometer and gyroscope
        guard let motionManager = motionManager,
              motionManager.isDeviceMotionAvailable else {

            return
        }
        // configuring time interval, that represents
        // how frequent accelerometer updates need to be
        motionManager.deviceMotionUpdateInterval = Constants.deviceMotionServiceTimeInterval
        motionManager.showsDeviceMovementDisplay = true
        // Start getting motion data in a specific way
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
        // creating current orientation variable with default value
        var currentOrientation: UIInterfaceOrientation = .landscapeRight {
            didSet {
                // every time current orientation is set, we call this func
                // To supress frequency of calling this function, we need to do
                // this only if we ACTUALLY change value
                if currentOrientation != oldValue {
                    deviceOrientationChanged(to: currentOrientation)
                }
            }
        }
        // Configure a timer to fetch the motion data.
        let block: (Timer) -> Void = { [weak self] (_) in
            if let data = self?.motionManager?.deviceMotion {
                let xAxis = data.gravity.x
                if xAxis > Constants.minDeviceMaxXAxis {
                    currentOrientation = .landscapeRight
                } else if xAxis < Constants.minDeviceMinXAxis {
                    currentOrientation = .landscapeLeft
                } else {
                    currentOrientation = .portrait
                }
            }
        }
        timer = Timer(fire: Date(),
                      interval: Constants.deviceMotionServiceTimeInterval,
                      repeats: true,
                      block: block)
        // Add the timer to the current run loop.
        guard let timer = self.timer else {
            return
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
    }
    
    private func stopMotionUpdates() {
        timer?.invalidate()
        motionManager?.stopDeviceMotionUpdates()
    }
}

extension StreamViewController {
    private enum Constants {
        // Hours spent to find this values. At this xAxis values
        // animation of iOS Interface rotation occurs
        static let minDeviceMaxXAxis: Double = 0.65
        static let minDeviceMinXAxis: Double = -0.65
        // How frequent motion updates will be. This is
        // Apple's recommended value
        static let deviceMotionServiceTimeInterval: TimeInterval = 1.0 / 60.0
    }
}
