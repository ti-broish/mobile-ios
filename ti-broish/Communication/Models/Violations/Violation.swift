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
}

struct Violation: Decodable {
    
    // MARK: Properties
    
    let id: String
    let description: String
    let pictures: [Picture]
    let sections: [Section]?
    let status: ViolationStatus
    let statusLocalized: String
    //let statusColor: String
    
}
