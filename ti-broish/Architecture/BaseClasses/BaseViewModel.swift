//
//  BaseViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.06.21.
//

import Foundation
import Combine

protocol DataFieldModel {
    
    var data: [InputFieldConfig] { get set }
    
    func loadDataFields()
    func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath)
    
    func setFieldValue(_ value: AnyObject?, forFieldAt index: Int)
    func getFieldValue(forFieldAt index: Int) -> AnyObject?
}

class BaseViewModel: DataFieldModel {
    
    private let builder = SendFieldsDataBuilder()
    let reloadDataPublisher = PassthroughSubject<Error?, Never>()
    let loadingPublisher = PassthroughSubject<Bool, Never>()
    var data: [InputFieldConfig] = [InputFieldConfig]()
    let validator = Validator()
    
    var isAbroad: Bool = false {
        didSet {
            loadDataFields()
        }
    }
    
    func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        assertionFailure("updateFieldValuel:at not implemented")
    }
    
    func loadDataFields() {
        assertionFailure("loadDataFields not implemented")
    }
    
    func setFieldValue(_ value: AnyObject?, forFieldAt index: Int) {
        data[index].data = value
    }
    
    func getFieldValue(forFieldAt index: Int) -> AnyObject? {
        return data[index].data
    }
    
    func indexForSendField(type: SendFieldType) -> Int? {
        return data.firstIndex(where: { config in
            guard let dataType = config.dataType as? SendFieldType else {
                return false
            }
            
            return dataType == type
        })
    }
    
    func dataForSendField(type: SendFieldType) -> AnyObject? {
        guard let index = indexForSendField(type: type) else {
            return nil
        }
        
        switch type {
        case .description, .name, .email, .phone:
            return data[index].data
        default:
            let item = data[index].data as? SearchItem
            
            return item?.data
        }
    }
    
    func getSearchType(for indexPath: IndexPath) -> SearchType? {
        let model = data[indexPath.row]
        
        guard let fieldType = model.dataType as? SendFieldType else {
            return nil
        }
        
        switch fieldType {
        case .countryCheckbox:
            return nil
        case .countries:
            return .countries
        case .electionRegion:
            return .electionRegions
        case .municipality:
            return .municipalities
        case .town:
            return .towns
        case .cityRegion:
            return .cityRegions
        case .section:
            return .sections
        case .sectionNumber:
            return nil
        case .description:
            return nil
        case .organization:
            return .organizations
        default:
            return nil
        }
    }
    
    func toggleCityRegionField() {
        guard
            let index = indexForSendField(type: .town),
            let town = dataForSendField(type: .town) as? Town
        else {
            if let cityRegionIndex = indexForSendField(type: .cityRegion) {
                data.remove(at: cityRegionIndex)
            }
            
            return
        }

        let cityRegionIndex = indexForSendField(type: .cityRegion)
        let cityRegions = town.cityRegions ?? []
        
        if cityRegions.count > 0 {
            if cityRegionIndex == nil {
                data.insert(builder.cityRegionConfig, at: index + 1)
            }
        } else if let cityRegionIndex = cityRegionIndex {
            data.remove(at: cityRegionIndex)
        }
    }
    
    func resetAndReload(fields: [SendFieldType]) {
        data.removeAll()
        
        fields.forEach { fieldType in
            if var config = builder.makeConfig(for: fieldType) {
                if fieldType == .section && (self is StartStreamViewModel || self is CheckinViewModel) {
                    config.isRequired = true
                }
                
                data.append(config)
            }
        }
    }
    
    func resetAll() {
        resetAndReload(fields: isAbroad ? SendFieldType.violationAbroadFields : SendFieldType.violationFields)
    }
    
    func resetFieldsData(for fieldType: SendFieldType) {
        switch fieldType {
        case .countries:
            resetFieldsData([.town, .section, .sectionNumber])
        case .electionRegion:
            resetFieldsData([.municipality, .town, .cityRegion, .section, .sectionNumber])
        case .municipality:
            resetFieldsData([.town, .cityRegion, .section, .sectionNumber])
        case .town:
            resetFieldsData([.cityRegion, .section, .sectionNumber])
        case .cityRegion:
            resetFieldsData([.section, .sectionNumber])
        default:
            break
        }
    }
    
    func prefillFieldValue(for fieldType: SendFieldType, value: AnyObject?) {
        switch fieldType {
        case .section:
            if let sectionNumberIndex = indexForSendField(type: .sectionNumber) {
                setFieldValue(value, forFieldAt: sectionNumberIndex)
            }
        default:
            break
        }
    }
    
    func errorMessageForField(type: SendFieldType) -> String? {
        guard let data = dataForSendField(type: type) else {
            switch type {
            case .countries:
                return LocalizedStrings.SendInputField.countryNotSet
            case .electionRegion:
                return LocalizedStrings.SendInputField.electionRegionNotSet
            case .municipality:
                return LocalizedStrings.SendInputField.municipalityNotSet
            case .town:
                return LocalizedStrings.SendInputField.townNotSet
            case .section:
                return LocalizedStrings.SendInputField.sectionNotSet
            case .description:
                return LocalizedStrings.SendInputField.descriptionNotSet
            default:
                return LocalizedStrings.Errors.defaultError
            }
        }
        
        if type == .town,
           let town = data as? Town,
           let cityRegions = town.cityRegions
        {
            if cityRegions.count > 0 && dataForSendField(type: .cityRegion) == nil {
                return LocalizedStrings.SendInputField.cityRegionNotSet
            }
        } else if type == .description {
            if let desc = data as? String, desc.count >= 20 {
                return nil
            } else {
                return LocalizedStrings.SendInputField.descriptionNotSet
            }
        }
        
        return nil
    }
    
    // MARK: - Private methods
    
    private func resetFieldsData(_ fields: [SendFieldType]) {
        fields.forEach { field in
            if let index = indexForSendField(type: field), index < data.count {
                data[index].data = nil
            }
        }
    }
}
