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
    case organization
    case name
    case email
    case phone

    static var protocolFields: [SendFieldType] {
        return [.section]
    }
    
    static var violationFields: [SendFieldType] {
        return [
            .countryCheckbox,
            .electionRegion,
            .municipality,
            .town,
            .section,
            .sectionNumber,
            .description,
            .name,
            .email,
            .phone
        ]
    }
    
    static var violationAbroadFields: [SendFieldType] {
        return [.countryCheckbox, .countries, .town, .section, .sectionNumber, .description, .name, .email, .phone]
    }
    
    static var streamingFields: [SendFieldType] {
        return [.countryCheckbox, .electionRegion, .municipality, .town, .section, .sectionNumber]
    }
    
    static var streamingAbroadFields: [SendFieldType] {
        return [.countryCheckbox, .countries, .town, .section, .sectionNumber]
    }
    
    static var checkinFields: [SendFieldType] {
        return [.countryCheckbox, .electionRegion, .municipality, .town, .section, .sectionNumber]
    }
    
    static var checkinAbroadFields: [SendFieldType] {
        return [.countryCheckbox, .countries, .town, .section, .sectionNumber]
    }
    
    static var storedCheckinFields: [SendFieldType] {
        return [.electionRegion, .municipality, .town, .cityRegion, .section]
    }
    
    static var storedCheckinAbroadFields: [SendFieldType] {
        return [.countries, .town, .section]
    }
}
