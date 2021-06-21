//
//  SendViolationDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import Foundation

enum SendViolationFieldType: Int, CaseIterable {
    
    case electionRegion
    case municipality
    case town
    case cityRegion
    case sectionNumber
}

struct SendViolationDataBuilder {
    
    func makeConfig(for type: SendViolationFieldType) -> InputFieldConfig {
        switch type {
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
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.cityRegion,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.cityRegion as AnyObject
            )
        case .sectionNumber:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.section,
                placeholderText: LocalizedStrings.SendInputField.sectionNumberPlaceholder,
                isRequired: true,
                dataType: SendViolationFieldType.sectionNumber as AnyObject
            )
        }
    }
}