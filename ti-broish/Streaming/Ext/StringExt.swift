//
//  StringExt.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 27.03.21.
//

import Foundation

extension String {
    
    func attributedText() -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        return attributedText
    }
    
    static func localized(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}

extension Optional where Wrapped == String  {
    
    func isNilOrEmpty() -> Bool {
        return self == nil || self?.isEmpty == true
    }
}
