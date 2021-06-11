//
//  BaseViewController.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 25.04.21.
//

import UIKit
import Combine

public enum PullToRefreshType {
    case `default`(color: UIColor?)
    case custom(view: UIView)
}

class BaseViewController: UIViewController, TibViewControllable {
    
    // MARK: - Properties
    
    private var pullToRefreshCustomView: UIView?
    var reloadDataSubscription: AnyCancellable?
    
    /// Override for custom logic for pull to refresh
    var pullToRefreshAction: (() -> Void)? {
        preconditionFailure("Override pullToRefreshAction if you're using pull to refresh")
    }
    
    /// Use by adding the refresh control and overriding pullToRefreshAction
    open lazy var refreshControl: UIRefreshControl = {
        let refreshControl: UIRefreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTheme()
    }
    
    func applyTheme() {
        let theme = TibTheme()
        self.view.backgroundColor = theme.backgroundColor
    }
    
    // MARK: - Actions
    
    @objc
    private func didPullToRefresh() {
        guard let refreshControlScroll = refreshControl.superview as? UIScrollView else { return }
        if refreshControlScroll.panGestureRecognizer.state == .changed {
            // The user hasn't lifted his finger yet
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.didPullToRefresh()
            }
        } else {
            // Only start the actual refresh when the pan gesture is in state ended/canceled
            pullToRefreshAction?()
            
        }
    }
    
    /// You can set a custom refresh control type. Either just a tint color of the default one
    /// or some custom view with custom animation logic.
    /// Important! -> make sure to call this BEFORE any pull to refresh happens if you want the changes to
    /// be preloaded when it does. pullToRefreshAction is NOT the place for this..
    /// - Parameter pullToRefreshType: The type that you want to set
    open func setRefreshControl(with pullToRefreshType: PullToRefreshType) {
        pullToRefreshCustomView?.removeFromSuperview()
        switch pullToRefreshType {
        case .default(let color):
            refreshControl.tintColor = color
        case .custom(let customView):
            customView.frame = refreshControl.bounds
            customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            customView.contentMode = .scaleAspectFit
            refreshControl.tintColor = .clear
            refreshControl.addSubview(customView)
            pullToRefreshCustomView = customView
        }
    }
}
