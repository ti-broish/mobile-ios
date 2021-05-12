//
//  Protocol.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias ProtocolsResponse = [Protocol]

enum ProtocolStatus: String, Decodable {
    case unknown
}

struct Protocol: Decodable {
    
    // MARK: Properites
    
    let id: String
    let pictures: [UploadPhoto]
    let section: Section
    let status: ProtocolStatus
    let statusLocalized: String
    let statusColor: String
    
}
