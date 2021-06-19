//
//  UploadImageCell.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 19.06.21.
//

import UIKit

final class UploadImageCell: TibTableViewCell {
    
    @IBOutlet private weak var mImageView: UIImageView!
    @IBOutlet private (set) weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        
        deleteButton.setImage(UIImage(named: SharedAssetsConfig.delete), for: .normal)
    }
    
    func configure(image: UIImage, indexPath: IndexPath) {
        mImageView.image = image
        deleteButton.tag = indexPath.row
    }
}
