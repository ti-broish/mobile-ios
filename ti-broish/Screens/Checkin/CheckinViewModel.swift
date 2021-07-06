//
//  CheckinViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import UIKit

final class CheckinViewModel: SendViewModel, CoordinatableViewModel {
    
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
        } else {
            resetAndReload(fields: SendFieldType.checkinFields)
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
                strongSelf.saveCheckin()
                strongSelf.sendPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.sendPublisher.send(error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func saveCheckin() {
        if isAbroad {
            
        } else {
            guard
                let electionRegion = dataForSendField(type: .electionRegion) as? ElectionRegion,
                let municipality = dataForSendField(type: .municipality) as? Municipality,
                let town = dataForSendField(type: .town) as? Town,
                let section = dataForSendField(type: .section) as? Section
            else {
                return
            }

            let encoder = JSONEncoder()

            if let electionRegionData = try? encoder.encode(electionRegion) {
                UserDefaults.standard.set(electionRegionData, forKey: "checkinElectionRegion")
            }
            
            if let municipalityData = try? encoder.encode(municipality) {
                UserDefaults.standard.set(municipalityData, forKey: "checkinMunicipality")
            }
            
            if let townData = try? encoder.encode(town) {
                UserDefaults.standard.set(townData, forKey: "checkinTown")
            }
            
            if let cityRegion = dataForSendField(type: .cityRegion) as? CityRegion,
               let cityRegionData = try? encoder.encode(cityRegion) {
                UserDefaults.standard.set(cityRegionData, forKey: "checkinCityRegion")
            }
            
            if let sectionData = try? encoder.encode(section) {
                UserDefaults.standard.set(sectionData, forKey: "checkinSection")
            }
        }
    }
}
