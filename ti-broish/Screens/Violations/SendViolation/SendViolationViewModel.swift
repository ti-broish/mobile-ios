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
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForField(type: fieldType)
        else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: index)
        toggleCityRegionField()
    }
    
    func reloadDataFields(isAbroad: Bool) {
        if isAbroad {
            resetAndReload(fields: SendFieldType.violationAbroadFields)
        } else {
            resetAndReload(fields: SendFieldType.violationFields)
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
    
    private func resetFields(_ fields: [SendFieldType]) {
        fields.forEach { field in
            if let index = indexForField(type: field), index < data.count {
                data[index].data = nil
            }
        }
    }
    
    private func resetFieldsData(for fieldType: SendFieldType) {
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
    
    private func resetAndReload(fields: [SendFieldType]) {
        data.removeAll()
        
        fields.forEach { fieldType in
            if let config = builder.makeConfig(for: fieldType) {
                data.append(config)
            }
        }
    }
}
