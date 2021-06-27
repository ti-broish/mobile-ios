//
//  SendFieldType.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 26.06.21.
//

import Foundation

enum SendFieldType {
    
    case countryCheckbox
    case countries
    case electionRegion
    case municipality
    case town
    case cityRegion
    case section
    case sectionNumber
    case description
    
    static var protocolFields: [SendFieldType] {
        return [.sectionNumber]
    }
    
    static var violationFields: [SendFieldType] {
        return [.countryCheckbox, .electionRegion, .municipality, .town, .section, .sectionNumber, .description]
    }
    
    static var violationAbroadFields: [SendFieldType] {
        return [.countryCheckbox, .countries, .town, .section, .sectionNumber, .description]
    }
}