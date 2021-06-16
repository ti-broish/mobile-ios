//
//  UINavigationItemExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.06.21.
//

import UIKit

extension UINavigationItem {
    
    func configureBackButton() {
        self.backBarButtonItem = UIBarButtonItem(
            title: LocalizedStrings.Buttons.back,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    func configureTitleView() {
        let imageView = UIImageView(image: UIImage(named: SharedAssetsConfig.navigationLogo))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.titleView = view
    }
}
