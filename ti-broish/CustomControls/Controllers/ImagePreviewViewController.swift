//
//  ImagePreviewViewController.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.06.21.
//

import UIKit

final class ImagePreviewViewController: BaseViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    
    var picture: Picture?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadImage()
    }
    
    // MARK: - Private methods
    
    @IBAction private func handleCloseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        closeButton.layer.cornerRadius = 4.0
        closeButton.backgroundColor = .primaryColor
        closeButton.setImage(UIImage(named: SharedAssetsConfig.close)?.withTintColor(.white), for: .normal)
    }
    
    private func loadImage() {
        // TODO: - implement image cache
        guard let picture = picture else {
            return
        }
        
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
                }
            } catch {
                print(error)
            }
        }
    }
}
