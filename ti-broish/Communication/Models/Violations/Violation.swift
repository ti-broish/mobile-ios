//
//  Violation.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

typealias ViolationsResponse = [Violation]

enum ViolationStatus: String, Decodable {
    
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

struct Violation: Decodable {
    
    // MARK: Properties
    
    let id: String
    let description: String
    let pictures: [Picture]
    let sections: [Section]?
    let status: ViolationStatus
    let statusLocalized: String
    let statusColor: String?
}
