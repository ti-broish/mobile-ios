//
//  PhotoButtonsCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 19.06.21.
//

import UIKit

final class PhotoButtonsCell: TibTableViewCell {
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var galleryView: UIView!
    @IBOutlet private (set) weak var galleryButton: UIButton!
    @IBOutlet private weak var galleryImageView: UIImageView!
    @IBOutlet private weak var galleryLabel: UILabel!
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private (set) weak var cameraButton: UIButton!
    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var cameraLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        stackView.spacing = 16.0
        
        messageLabel.textColor = .darkText
        messageLabel.font = .regularFont(size: 14.0)
        messageLabel.numberOfLines = 0
        messageLabel.setText(LocalizedStrings.Photos.message, isRequired: true)
        
        galleryView.layer.cornerRadius = 4.0
        galleryView.backgroundColor = .primaryColor
        galleryImageView.image = UIImage(named: SharedAssetsConfig.gallery)?.withTintColor(.white)
        galleryLabel.font = .regularFont(size: 14.0)
        galleryLabel.textColor = .white
        galleryLabel.text = LocalizedStrings.Buttons.gallery
        
        cameraView.layer.cornerRadius = 4.0
        cameraView.backgroundColor = .primaryColor
        cameraImageView.image = UIImage(named: SharedAssetsConfig.camera)?.withTintColor(.white)
        cameraLabel.font = .regularFont(size: 14.0)
        cameraLabel.textColor = .white
        cameraLabel.text = LocalizedStrings.Buttons.camera
        
        if DeviceType.isPad {
            stackView.distribution = .fillEqually
            galleryLabel.textAlignment = .center
            cameraLabel.textAlignment = .center
        }
    }
    
    func hideMessage() {
        messageLabel.text = ""
        messageLabel.isHidden = true
    }
}
