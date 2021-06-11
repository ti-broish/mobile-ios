//
//  Protocol.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias ProtocolsResponse = [Protocol]

enum ProtocolStatus: String, Decodable {
    
    case received, rejected, approved, processed
    
    var colorString: String {
        switch (self) {
        case .received:
            return "#FF9900"
        case .rejected:
            return "#FF0000"
        case .approved:
            return "#4CAF50"
        case .processed:
            return "#4CAF50"
        }
    }
}

struct Picture: Decodable {
    
    let id: String
    let path: String
    let rotation: Int
    let url: String
}

struct Protocol: Decodable {
    
    // MARK: Properites
    
    let id: String
    let pictures: [Picture]
    let section: Section
    let status: ProtocolStatus
    let statusLocalized: String
    let statusColor: String?
    
}
