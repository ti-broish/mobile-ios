//
//  Section.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation

typealias SectionsResponse = [Section]

struct Section: Codable {
    
    // MARK: Properties
    
    let id: String
    let code: String
    let place: String
    let name: String?
    
    let isMachine: Bool?
    let isMobile: Bool?
    let isShip: Bool?
    
    init(
        id: String,
        code: String,
        place: String,
        name: String? = nil,
        isMachine: Bool? = nil,
        isMobile: Bool? = nil,
        isShip: Bool? = nil
    ) {
        self.id = id
        self.code = code
        self.place = place
        self.name = name
        self.isMachine = isMachine
        self.isMobile = isMobile
        self.isShip = isShip
    }
}
