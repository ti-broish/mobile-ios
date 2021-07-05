//
//  ImagePreviewViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.06.21.
//

import UIKit

final class ImagePreviewViewController: BaseViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    
    var picture: Picture?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadImage()
    }
    
    override func applyTheme() {
        super.applyTheme()
        scrollView.backgroundColor = view.backgroundColor
    }
    
    // MARK: - Private methods
    
    @IBAction private func handleCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        guard let scale = scaleResult, scale.a > 1.0, scale.d > 1.0 else {
            return
        }
        
        sender.view?.transform = scale
        sender.scale = 1.0
    }
    
    private func addPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture))
        view.addGestureRecognizer(pinchGesture)
    }
    
    private func setupViews() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 10.0
        
        closeButton.layer.cornerRadius = 4.0
        closeButton.backgroundColor = .primaryColor
        closeButton.setImage(UIImage(named: SharedAssetsConfig.close)?.withTintColor(.white), for: .normal)
        
        addPinchGesture()
    }
    
    private func updateMinimumZoomScale() {
        guard let image = imageView.image else {
            return
        }
        
        let imageWidth = CGFloat(scrollView.bounds.size.width / image.size.width)
        let imageHeight = CGFloat(scrollView.bounds.size.height / image.size.height)
        let minZoom: CGFloat = min(imageWidth, imageHeight)
        
        if (minZoom <= 1.0) {
            scrollView.minimumZoomScale = minZoom
            scrollView.zoomScale = minZoom
        }
    }
    
    private func loadImage() {
        // TODO: - implement image cache
        guard let picture = picture else {
            return
        }
        
        view.showLoading()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            do {
                guard let imageUrl = URL(string: picture.url) else {
                    return
                }
                
                let data = try Data(contentsOf: imageUrl)
                
                DispatchQueue.main.async {
                    strongSelf.imageView.image = UIImage(data: data)
                    strongSelf.scrollView.contentSize = strongSelf.imageView.image?.size ?? .zero
                    strongSelf.updateMinimumZoomScale()
                    strongSelf.view.hideLoading()
                }
            } catch {
                print(error)
                strongSelf.view.hideLoading()
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension ImagePreviewViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
