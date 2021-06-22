//
//  JsonExt.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 30.03.21.
//

import Foundation

extension JSONEncoder {
    static var `default`: JSONEncoder {
        get {
            return JSONEncoder()
        }
    }
}

extension JSONDecoder {
    static var `default`: JSONDecoder {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            return jsonDecoder
        }
    }
}
