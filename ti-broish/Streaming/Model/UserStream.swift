//
//  UserStream.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 30.03.21.
//

import Foundation

class UserStream: Codable {
    
    let streamUrl: String?
    let viewUrl: String?
    
    var streamConnectionUrl: String? = nil
    var streamName: String? = nil
    
    init(streamUrl: String, viewUrl: String) {
        self.streamUrl = streamUrl
        self.viewUrl = viewUrl
        let _ = initStreamUrlComponents()
    }
    
    enum CodingKeys: String, CodingKey {
        case streamUrl = "streamUrl"
        case viewUrl = "viewUrl"
        case streamConnectionUrl = "streamConnectionUrl"
        case streamName = "streamName"
    }
}

extension UserStream {
    
    func initStreamUrlComponents() -> Bool {
        guard let urlString = streamUrl else { return false }
        guard let url = URL(string: urlString) else { return false }
        let streamName = url.lastPathComponent
        if (streamName.isEmpty) { return false }
        
        streamConnectionUrl = url.absoluteString.replacingOccurrences(of: "/\(streamName)", with: "")
        self.streamName = streamName
        return true
    }
}
