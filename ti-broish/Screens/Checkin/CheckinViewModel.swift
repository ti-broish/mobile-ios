//
//  CheckinViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit

final class CheckinViewModel: SendViewModel, CoordinatableViewModel {
    
    private let checkinUtils = CheckinUtils()
    
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
            resetAndReload(fields: SendFieldType.checkinAbroadFields)
            tryLoadCheckinData(fields: [.countries, .town, .section])
        } else {
            resetAndReload(fields: SendFieldType.checkinFields)
            tryLoadCheckinData(fields: [.electionRegion, .municipality, .town, .cityRegion, .section])
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
    
    func sendCheckin() {
        guard let section = dataForSendField(type: .section) as? Section else {
            return
        }

        loadingPublisher.send(true)
        APIManager.shared.sendCheckin(section: section) { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .success(_):
                strongSelf.saveCheckinData()
                strongSelf.sendPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.sendPublisher.send(error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func saveCheckinData() {
        checkinUtils.storeCheckin(
            data: [
                .countries: dataForSendField(type: .countries),
                .electionRegion: dataForSendField(type: .electionRegion),
                .municipality: dataForSendField(type: .municipality),
                .town: dataForSendField(type: .town),
                .cityRegion: dataForSendField(type: .cityRegion),
                .section: dataForSendField(type: .section)
            ])
    }
    
    private func loadCheckinData(_ checkinData: [SendFieldType: AnyObject?], fields: [SendFieldType]) {
        for field in fields {
            if let index = indexForSendField(type: field) {
                if let value = checkinData[field] {
                    resetFieldsData(for: field)
                    setFieldValue(value, forFieldAt: index)
                    toggleCityRegionField()
                    prefillFieldValue(for: field, value: value)
                }
            }
        }
    }
    
    private func tryLoadCheckinData(fields: [SendFieldType]) {
        let checkinData = checkinUtils.getStoredCheckinData()
        
        if isAbroad {
            guard checkinData[.countries] != nil else {
                return
            }
            
            loadCheckinData(checkinData, fields: fields)
        } else {
            guard checkinData[.countries] == nil else {
                return
            }
            
            loadCheckinData(checkinData, fields: fields)
        }
    }
}
