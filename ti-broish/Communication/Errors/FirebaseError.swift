//
//  FirebaseError.swift
//  ti-broish
//
//  Created by Martin Sotirov on 01.05.21.
//

import Foundation

enum FirebaseError: Error {
    case invalidEmail
    case userNotFound
    case wrongPassword
    case other
}
