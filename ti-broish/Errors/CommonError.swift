//
//  CommonError.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

enum ErrorCommon: Error {
    
    case defaultError
    
    var message: String {
        switch self {
        default:
            return LocalizedStrings.Errors.defaultError
        }
    }
}
