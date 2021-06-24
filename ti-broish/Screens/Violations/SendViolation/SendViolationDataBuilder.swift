//
//  SendViolationDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import Foundation

enum SendViolationFieldType: Int, CaseIterable {
    
    case countryCheckbox
    case countries
    case electionRegion
    case municipality
    case town
    case cityRegion
    case section
    case sectionNumber
    case description
    
    static var defaultFields: [SendViolationFieldType] {
        return [.countryCheckbox, .electionRegion, .municipality, .town, .section, .description]
    }
    
    static var abroadFields: [SendViolationFieldType] {
        return [.countryCheckbox, .countries, .town, .section, .description]
    }
}

struct SendViolationDataBuilder {
    
    var cityRegionConfig: InputFieldConfig {
        return InputFieldConfig(
            type: .picker,
            title: LocalizedStrings.SendInputField.cityRegion,
            placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
            isRequired: true,
            dataType: SendViolationFieldType.cityRegion as AnyObject
        )
    }
    
    var sectionNumberConfig: InputFieldConfig {
        return InputFieldConfig(
            type: .text,
            title: LocalizedStrings.SendInputField.sectionNumber,
            placeholderText: "",
            isRequired: false,
            dataType: SendViolationFieldType.cityRegion as AnyObject
        )
    }
    
    func makeConfig(for type: SendViolationFieldType) -> InputFieldConfig? {
        switch type {
        case .countryCheckbox:
            return InputFieldConfig(
                type: .checkbox,
                title: LocalizedStrings.SendInputField.country,
                placeholderText: "",
                isRequired: true,
                dataType: SendViolationFieldType.countryCheckbox as AnyObject
            )
        case .countries:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.country,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.countries as AnyObject
            )
        case .electionRegion:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.electionRegion,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.electionRegion as AnyObject
            )
        case .municipality:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.municipality,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.municipality as AnyObject
            )
        case .town:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.town,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder, 
                isRequired: true,
                dataType: SendViolationFieldType.town as AnyObject
            )
        case .cityRegion:
            return nil
        case .section:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.section,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.section as AnyObject
            )
        case .sectionNumber:
            return nil
        case .description:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.description,
                placeholderText: LocalizedStrings.SendInputField.descriptionPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.description as AnyObject
            )
        }
    }
}
