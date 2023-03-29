//
//  Violation.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

typealias ViolationsResponse = [Violation]

enum ViolationStatus: String, Codable {
    
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

struct Violation: Decodable {
    
    // MARK: Properties
    
    let id: String
    let description: String
    let pictures: [Picture]
    let section: Section?
    let status: ViolationStatus
    let statusLocalized: String
    let statusColor: String?
}
