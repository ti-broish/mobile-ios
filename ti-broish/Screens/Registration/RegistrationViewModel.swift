//
//  RegistrationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.04.21.
//

import Foundation
import Combine
import Firebase

final class RegistrationViewModel: BaseViewModel, CoordinatableViewModel {
    
    let registrationPublisher = PassthroughSubject<String, Never>()
    let registrationFailedPublisher = PassthroughSubject<String, Never>()
    var countryPhoneCode: CountryPhoneCode?
    private var registrationAttempts = 0
    
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
    
    override func loadDataFields() {
        let builder = RegistrationDataBuilder()
        
        RegistrationFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = RegistrationFieldType(rawValue: indexPath.row) else {
            return
        }
        
        setFieldValue(value, forFieldAt: field.rawValue)
    }
    
    func start() {
        loadDataFields()
    }
    
    /// Register firebase user
    func register() {
        guard
            let email = getFieldValue(forFieldAt: indexFor(field: .email)) as? String,
            let password = getFieldValue(forFieldAt: indexFor(field: .password)) as? String,
            let userDetails = makeUserDetails()
        else {
            registrationFailedPublisher.send(LocalizedStrings.Errors.invalidUserDetails)
            return
        }
        
        loadingPublisher.send(true)
        APIManager.shared.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let firebaseUid):
                self?.createUser(user: User(firebaseUid: firebaseUid, userDetails: userDetails))
            case .failure(let error):
                if error == .emailAlreadyInUse && self?.registrationAttempts == 0 {
                    self?.loginUser(email: email, password: password, userDetails: userDetails)
                } else {
                    self?.registrationFailedPublisher.send(error.localizedString)
                }
            }
        }
    }
    
    // MARK: - Private methods
    
    private func indexFor(field: RegistrationFieldType) -> Int {
        return field.rawValue
    }
    
    private func makeUserDetails() -> UserDetails? {
        guard
            let firstName = getFieldValue(forFieldAt: indexFor(field: .firstName)) as? String,
            let lastName = getFieldValue(forFieldAt: indexFor(field: .lastName)) as? String,
            let email = getFieldValue(forFieldAt: indexFor(field: .email)) as? String,
            let phone = getFieldValue(forFieldAt: indexFor(field: .phone)) as? String,
            let pin = getFieldValue(forFieldAt: indexFor(field: .pin)) as? String,
            let organization = dataForSendField(type: .organization) as? Organization,
            let hasAgreedToKeepData = getFieldValue(forFieldAt: indexFor(field: .hasAgreedToKeepData)) as? CheckboxState
        else {
            return nil
        }
        
        let phoneCode = countryPhoneCode ?? CountryPhoneCode.defaultCountryPhoneCode
        
        return UserDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: "\(phoneCode.code)\(phone)",
            pin: pin,
            hasAgreedToKeepData: hasAgreedToKeepData == .checked,
            organization: organization
        )
    }
    
    private func sendEmailVerification() {
        APIManager.shared.sendEmailVerification { [weak self] result in
            switch result {
            case .success:
                self?.registrationPublisher.send(LocalizedStrings.Registration.emailVerification)
            case .failure(let error):
                self?.registrationFailedPublisher.send(error.localizedDescription)
            }
        }
    }
    
    /// Create user (API)
    private func createUser(user: User) {
        APIManager.shared.createUser(user) { [weak self] result in
            switch result {
            case .success:
                self?.sendEmailVerification()
            case .failure(let error):
                self?.registrationFailedPublisher.send(error.localizedDescription)
            }
        }
    }
    
    private func loginUser(email: String, password: String, userDetails: UserDetails) {
        APIManager.shared.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let token):
                LocalStorage.User().setJwt(token)
                
                if let uid = Auth.auth().currentUser?.uid {
                    self?.registrationAttempts += 1
                    
                    self?.createUser(user: User(firebaseUid: uid, userDetails: userDetails))
                } else {
                    self?.registrationFailedPublisher.send(LocalizedStrings.Errors.defaultError)
                }
            case .failure(let error):
                self?.registrationFailedPublisher.send(error.localizedString)
            }
        }
    }
}
