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
    
    override func loadDataFields() {
        SendViolationFieldType.allCases.forEach { fieldType in
            if let config = builder.makeConfig(for: fieldType) {
                data.append(config)
            }
        }
    }
    
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
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let fieldType = SendViolationFieldType(rawValue: indexPath.row) else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: fieldType.rawValue)
        
        if fieldType == .town {
            let index = SendViolationFieldType.cityRegion.rawValue
            let item = value as? SearchItem
            
            if let town = item?.data as? Town, town.cityRegions.count > 0 {
                data.insert(builder.cityRegionConfig, at: index)
            } else if let dataType = data[index].dataType as? SendViolationFieldType, dataType == .cityRegion {
                data.remove(at: index)
            }
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
        loadDataFields()
    }
    
    // MARK: - Private methods
}
