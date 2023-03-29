//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: SendViewModel, CoordinatableViewModel {
    var countryPhoneCode: CountryPhoneCode?
    
    var phoneIndexPath: IndexPath? {
        guard let index = data.firstIndex(where: { $0.type == .phone }) else {
            return nil
        }
        
        return IndexPath(row: index, section: 0)
    }
    
    var countryPhoneCodeSearchItem: SearchItem? {
        let countryPhoneCode = countryPhoneCode ?? CountryPhoneCode.defaultCountryPhoneCode
        
        return SearchItem(id: -1, name: countryPhoneCode.name, code: countryPhoneCode.code, type: .phoneCode)
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
    
    override func errorMessageForField(type: SendFieldType) -> String? {
        guard [.name, .email, .phone].contains(type) else {
            return super.errorMessageForField(type: type)
        }
        
        if let data = dataForSendField(type: type) {
            switch type {
            case .name:
                if !validator.validate(name: data as? String) {
                    return LocalizedStrings.Errors.invalidName
                }
            case .email:
                if !validator.validate(email: data as? String) {
                    return LocalizedStrings.Errors.invalidEmail
                }
            case .phone:
                if !validator.validate(phone: data as? String) {
                    return LocalizedStrings.Errors.invalidPhone
                }
            default:
                break
            }
        } else {
            switch type {
            case .name:
                return LocalizedStrings.SendInputField.nameNotSet
            case .email:
                return LocalizedStrings.SendInputField.emailNotSet
            case .phone:
                return LocalizedStrings.SendInputField.phoneNotSet
            default:
                return LocalizedStrings.Errors.defaultError
            }
        }
        
        return nil
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
            let descriptionText = dataForSendField(type: .description) as? String,
            let name = dataForSendField(type: .name) as? String,
            let email = dataForSendField(type: .email) as? String,
            let phone = dataForSendField(type: .phone) as? String
        else {
            return
        }
        
        let pictures = uploadPhotos.map { $0.id }
        let section = dataForSendField(type: .section) as? Section
        
        let phoneCode = countryPhoneCode?.code ?? CountryPhoneCode.defaultCountryPhoneCode.code
        let contacts = ViolationContacts(name: name, email: email, phone: "\(phoneCode)\(phone)")
        
        APIManager.shared.sendViolation(
            town: town,
            pictures: pictures,
            description: descriptionText,
            section: section,
            contacts: contacts
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
