//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: BaseViewModel, CoordinatableViewModel {
    
    private let builder = SendViolationDataBuilder()
    private (set) var images = [UIImage]()
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let fieldType = SendViolationFieldType(rawValue: indexPath.row) else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: fieldType.rawValue)
        toggleCityRegionField()
    }
    
    func reloadDataFields(isAbroad: Bool) {
        if isAbroad {
            resetAndReload(fields: SendViolationFieldType.abroadFields)
        } else {
            resetAndReload(fields: SendViolationFieldType.defaultFields)
        }
    }
    
    func setImages(_ images: [UIImage]) {
        images.forEach { image in
            if self.images.first(where: { $0 == image }) == nil {
                self.images.append(image)
            }
        }
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
    }
    
    func start() {
        reloadDataFields(isAbroad: false)
    }
    
    func indexForField(type: SendViolationFieldType) -> Int? {
        return data.firstIndex(where: { config in
            guard let dataType = config.dataType as? SendViolationFieldType else {
                return false
            }
            
            return dataType == type
        })
    }
    
    func dataForField(type: SendViolationFieldType) -> AnyObject? {
        guard let index = indexForField(type: type) else {
            return nil
        }
        
        return data[index].data
    }
    
    func hasCityRegions() -> Bool {
        guard
            let item = dataForField(type: .town) as? SearchItem,
            let town = item.data as? Town,
            let cityRegions = town.cityRegions
        else {
            return false
        }
        
        return cityRegions.count > 0
    }
    
    func getSearchType(for indexPath: IndexPath) -> SearchType? {
        let model = data[indexPath.row]
        
        guard let fieldType = model.dataType as? SendViolationFieldType else {
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
        case .description:
            return nil
        }
    }
    
    func getCountry() -> Country {
        guard
            let item = dataForField(type: .countries) as? SearchItem,
            let country = item.data as? Country
        else {
            return Country(code: "00", name: "България", isAbroad: false)
        }
        
        return country
    }
    
    // MARK: - Private methods
    
    private func resetFields(_ fields: [SendViolationFieldType]) {
        fields.forEach { field in
            let index = field.rawValue
            
            if index < data.count {
                data[index].data = nil
            }
        }
    }
    
    private func resetFieldsData(for fieldType: SendViolationFieldType) {
        switch fieldType {
        case .electionRegion:
            resetFields([.municipality, .town, .cityRegion, .section])
        case .municipality:
            resetFields([.town, .cityRegion, .section])
        case .town:
            resetFields([.cityRegion, .section])
        case .cityRegion:
            resetFields([.section])
        default:
            break
        }
    }
    
    private func toggleCityRegionField() {
        guard
            let townIndex = indexForField(type: .town),
            let item = data[townIndex].data as? SearchItem,
            let town = item.data as? Town
        else {
            return
        }

        let cityRegionIndex = indexForField(type: .cityRegion)
        let cityRegions = town.cityRegions ?? []
        
        if cityRegions.count > 0 {
            if cityRegionIndex == nil {
                data.insert(builder.cityRegionConfig, at: townIndex + 1)
            }
        } else if let cityRegionIndex = cityRegionIndex {
            data.remove(at: cityRegionIndex)
        }
    }
    
    private func resetAndReload(fields: [SendViolationFieldType]) {
        data.removeAll()
        
        fields.forEach { fieldType in
            if let config = builder.makeConfig(for: fieldType) {
                data.append(config)
            }
        }
    }
}
