//
//  ImageCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.06.21.
//

import UIKit

final class ImageCell: UICollectionViewCell, Cell {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 4.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.grayTextColor.cgColor
        
        spinner.color = .grayTextColor
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
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
                    strongSelf.imageView.layer.borderWidth = 0.0
                    strongSelf.spinner.stopAnimating()
                }
            } catch {
                print(error)
                
                DispatchQueue.main.async {
                    strongSelf.spinner.stopAnimating()
                }
            }
        }
    }
}
