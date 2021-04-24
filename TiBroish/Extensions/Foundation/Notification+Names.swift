//
//  Notification+Names.swift
//  TiBroish
//
//  Created by Viktor Georgiev on 24.04.21.
//

import Foundation

public extension Notification.Name {
    static let willEnterForeground = Notification.Name(rawValue: "willEnterForeground")
    static let didEnterBackground = Notification.Name(rawValue: "didEnterBackground")
}
