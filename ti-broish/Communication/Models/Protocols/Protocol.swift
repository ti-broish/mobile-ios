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
    let statusColor: Int?
    
}
