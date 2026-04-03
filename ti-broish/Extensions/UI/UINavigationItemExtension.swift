//
//  UINavigationItemExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.06.21.
//

import UIKit

extension UINavigationItem {
    
    private static let navigationLogoHeight: CGFloat = 44.0
    
    func configureBackButton() {
        self.backBarButtonItem = UIBarButtonItem(
            title: LocalizedStrings.Buttons.back,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    func configureTitleView() {
        guard let image = UIImage(named: SharedAssetsConfig.navigationLogo) else {
            titleView = nil
            return
        }
        
        let logoHeight = Self.navigationLogoHeight
        let logoWidth = max(logoHeight, image.size.width * (logoHeight / image.size.height))
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: logoWidth, height: logoHeight))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: logoWidth),
            view.heightAnchor.constraint(equalToConstant: logoHeight),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.titleView = view
    }
}
