//
//  SendFieldsDataBuilder.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import Foundation

struct SendFieldsDataBuilder {
    
    var cityRegionConfig: InputFieldConfig {
        return InputFieldConfig(
            type: .picker,
            title: LocalizedStrings.SendInputField.cityRegion,
            placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
            isRequired: true,
            dataType: SendFieldType.cityRegion as AnyObject
        )
    }
    
    func makeConfig(for type: SendFieldType) -> InputFieldConfig? {
        switch type {
        case .countryCheckbox:
            return InputFieldConfig(
                type: .checkbox,
                title: LocalizedStrings.SendInputField.country,
                placeholderText: nil,
                isRequired: true,
                dataType: SendFieldType.countryCheckbox as AnyObject
            )
        case .countries:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.country,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendFieldType.countries as AnyObject
            )
        case .electionRegion:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.electionRegion,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendFieldType.electionRegion as AnyObject
            )
        case .municipality:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.municipality,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendFieldType.municipality as AnyObject
            )
        case .town:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.town,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: true,
                dataType: SendFieldType.town as AnyObject
            )
        case .cityRegion:
            return nil
        case .section:
            return InputFieldConfig(
                type: .picker,
                title: LocalizedStrings.SendInputField.section,
                placeholderText: LocalizedStrings.Search.searchBarPlaceholder,
                isRequired: false,
                dataType: SendFieldType.section as AnyObject
            )
        case .sectionNumber:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.sectionNumber,
                placeholderText: nil,
                isRequired: false,
                dataType: SendFieldType.sectionNumber as AnyObject
            )
        case .description:
            return InputFieldConfig(
                type: .text,
                title: LocalizedStrings.SendInputField.description,
                placeholderText: LocalizedStrings.SendInputField.descriptionPlaceholder,
                isRequired: true,
                dataType: SendFieldType.description as AnyObject
            )
        }
    }
}
