//
//  DeviceType.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 1.07.21.
//

import UIKit

struct DeviceType {

    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
