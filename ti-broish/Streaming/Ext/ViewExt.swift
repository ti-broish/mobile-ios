//
//  ViewExt.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 28.03.21.
//

import UIKit

extension UIView {
    func setRotation(radians: CGFloat) {
        if (radians == 0) {
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = .identity
            })
        } else {
            self.transform = .identity
            let rotation = self.transform.rotated(by: radians)
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = rotation
            })
        }
    }
}
