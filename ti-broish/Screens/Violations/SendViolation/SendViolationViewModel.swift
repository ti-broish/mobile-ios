//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: SendViewModel, CoordinatableViewModel {
    
    override var canSend: Bool {
        guard
            let _ = dataForSendField(type: .town) as? Town,
            let _ = dataForSendField(type: .description) as? String
        else {
            return false
        }
        
        if images.count > 0 {
            return images.count == uploadPhotos.count
        } else {
            return true
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForSendField(type: fieldType)
        else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: index)
        toggleCityRegionField()
        prefillFieldValue(for: fieldType, value: value)
    }
    
    override func loadDataFields() {
        if isAbroad {
            resetAndReload(fields: SendFieldType.violationAbroadFields)
        } else {
            resetAndReload(fields: SendFieldType.violationFields)
        }
    }
    
    override func resetAll() {
        super.resetAll()
        
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    func start() {
        loadDataFields()
    }
    
    func sendViolation() {
        loadingPublisher.send(true)
        
        guard
            let town = dataForSendField(type: .town) as? Town,
            let descriptionText = dataForSendField(type: .description) as? String
        else {
            return
        }
        
        let pictures = uploadPhotos.map { $0.id }
        let section = dataForSendField(type: .section) as? Section
        
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
                strongSelf.resetAll()
                strongSelf.sendPublisher.send(nil)
            case .failure(let error):
                strongSelf.uploadPhotos.removeAll()
                strongSelf.sendPublisher.send(error)
            }
        }
    }
}
