//
//  UserDefaultsExtension.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.05.21.
//

import Foundation

extension UserDefaults {
    
    func stringValue(forKey key: String) -> String? {
        guard let object = object(forKey: key), let strObject = object as? String else {
            return nil
        }
        
        return strObject
    }
}
