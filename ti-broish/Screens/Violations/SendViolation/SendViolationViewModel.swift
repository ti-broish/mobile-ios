//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: SendViewModel, CoordinatableViewModel {
    
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
            tryLoadCheckinData(fields: SendFieldType.storedCheckinAbroadFields)
        } else {
            resetAndReload(fields: SendFieldType.violationFields)
            tryLoadCheckinData(fields: SendFieldType.storedCheckinFields)
        }
    }
    
    override func resetAll() {
        super.resetAll()
        
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    func start() {
        isAbroad = checkinUtils.isAbroad
        
        loadDataFields()
    }
    
    func trySendViolation() {
        if images.count > 0 {
            uploadImages { [weak self] result in
                switch result {
                case .success:
                    self?.sendViolation()
                case .failure(let error):
                    self?.sendPublisher.send(error)
                }
            }
        } else {
            loadingPublisher.send(true)
            sendViolation()
        }
    }
    
    // MARK: - Private methods
    
    private func sendViolation() {
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
            case .success(_):
                strongSelf.resetAll()
                strongSelf.sendPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.sendPublisher.send(error)
            }
        }
    }
}
