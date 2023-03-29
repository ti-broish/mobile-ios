//
//  Protocol.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

typealias ProtocolsResponse = [Protocol]

enum ProtocolStatus: String, Codable {
    
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
    
    var localizedStatus: String {
        switch (self) {
        case .received:
            return "Получен"
        case .rejected:
            return "Отхвърлен"
        case .approved:
            return "Одобрен"
        case .processed:
            return "Обработва се"
        }
    }
}

struct Picture: Codable {
    
    let id: String
    let path: String
    let rotation: Int
    let url: String
}

struct Protocol: Decodable {
    
    // MARK: Properites
    
    let id: String
    let pictures: [Picture]
    let section: Section?
    let status: ProtocolStatus
    let statusLocalized: String
    let statusColor: String?
    
}
