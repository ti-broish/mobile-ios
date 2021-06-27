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
    private var uploadPhotos = [UploadPhoto]()
    private var isAbroad: Bool = false
    
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
        prefillFieldValues(for: fieldType, value: value)
    }
    
    func reloadDataFields(isAbroad: Bool) {
        self.isAbroad = isAbroad
        
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
            let town = dataForField(type: .town) as? Town,
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
    
    func trySendViolation() {
        if images.count > 0 {
            uploadImages()
        } else {
            loadingPublisher.send(true)
            sendViolation()
        }
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
            resetFields([.municipality, .town, .cityRegion, .section, .sectionNumber])
        case .municipality:
            resetFields([.town, .cityRegion, .section, .sectionNumber])
        case .town:
            resetFields([.cityRegion, .section, .sectionNumber])
        case .cityRegion:
            resetFields([.section, .sectionNumber])
        default:
            break
        }
    }
    
    private func toggleCityRegionField() {
        guard
            let index = indexForField(type: .town),
            let town = dataForField(type: .town) as? Town
        else {
            return
        }

        let cityRegionIndex = indexForField(type: .cityRegion)
        let cityRegions = town.cityRegions ?? []
        
        if cityRegions.count > 0 {
            if cityRegionIndex == nil {
                data.insert(builder.cityRegionConfig, at: index + 1)
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
    
    private func prefillFieldValues(for fieldType: SendFieldType, value: AnyObject?) {
        switch fieldType {
        case .section:
            if let sectionNumberIndex = indexForField(type: .sectionNumber) {
                setFieldValue(value, forFieldAt: sectionNumberIndex)
            }
        default:
            break
        }
    }
    
    private func reset() {
        resetFields(isAbroad ? SendFieldType.violationAbroadFields : SendFieldType.violationFields)
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    private func sendViolation() {
        guard
            let town = dataForField(type: .town) as? Town,
            let descriptionText = dataForField(type: .description) as? String
        else {
            return
        }
        
        let pictures = uploadPhotos.map { $0.id }
        let section = dataForField(type: .section) as? Section
        
        APIManager.shared.sendViolation(
            town: town,
            pictures: pictures,
            description: descriptionText,
            section: section
        ) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let violation):
                print("violation sent: \(violation)")
                strongSelf.reset()
                strongSelf.sendPublisher.send(nil)
            case .failure(let error):
                strongSelf.uploadPhotos.removeAll()
                strongSelf.sendPublisher.send(error)
            }
        }
    }
    
    private func uploadImages() {
        loadingPublisher.send(true)
        images.forEach { [weak self] image in
            guard let strongSelf = self else {
                return
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                let photo = Photo(base64: base64String)
                
                APIManager.shared.uploadPhoto(photo) { result in
                    switch result {
                    case .success(let uploadPhoto):
                        print("upload photo: \(uploadPhoto)")
                        strongSelf.uploadPhotos.append(uploadPhoto)
                        
                        if strongSelf.uploadPhotos.count == strongSelf.images.count {
                            strongSelf.sendViolation()
                        }
                    case .failure(let error):
                        print("failed to upload photo: \(error)")
                        strongSelf.uploadPhotos.removeAll()
                        strongSelf.sendPublisher.send(error)
                    }
                }
            }
        }
    }
}
