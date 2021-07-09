//
//  ImageCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.06.21.
//

import UIKit
import Photos

final class ImageCell: UICollectionViewCell, Cell {
    
    @IBOutlet private (set) weak var imageView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let theme = TibTheme()
        imageView.setBorder(color: theme.darkTextColor)
        
        spinner.color = theme.darkTextColor
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
    }
    
    func setSelected(_ isSelected: Bool) {
        isSelected ? imageView.setBorder(color: .primaryColor) : imageView.removeBorder()
    }
    
    func configure(picture: Picture?) {
        guard let picture = picture else {
            spinner.stopAnimating()
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            do {
                guard let imageUrl = URL(string: picture.url) else {
                    strongSelf.spinner.stopAnimating()
                    return
                }
                
                let data = try Data(contentsOf: imageUrl)
                
                DispatchQueue.main.async {
                    strongSelf.imageView.image = UIImage(data: data)
                    strongSelf.imageView.removeBorder()
                    strongSelf.spinner.stopAnimating()
                }
            } catch {
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                }
            }
        }
    }
    
    func configure(asset: PHAsset?) {
        guard let asset = asset else {
            spinner.stopAnimating()
            return
        }
        
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: CGSize(width: 2048, height: 2048),
            contentMode: .aspectFit,
            options: nil
        ) { (image, _) in
            DispatchQueue.main.async { [unowned self] in
                imageView.image = image
                imageView.removeBorder()
                spinner.stopAnimating()
            }
        }
    }
}
