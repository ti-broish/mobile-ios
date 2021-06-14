//
//  ProfileViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation
import Firebase

final class ProfileViewModel: BaseViewModel, CoordinatableViewModel {
    
    private var userDetails: UserDetails?
    private (set) var data = [InputFieldConfig]()
    
    override init() {
        super.init()
        loadProfileFields()
    }

    func start() {
        getProfile()
    }
    
    func updateValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = ProfileFieldType(rawValue: indexPath.row) else {
            return
        }
        
        setValue(value, for: field)
    }
    
    func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            // TODO: - show error
            return
        }

        guard let userDetails = makeUserDetails() else {
            // TODO: - show error
            return
        }

        let user = User(firebaseUid: uid, userDetails: userDetails)
        
        APIManager.shared.updateUserDetails(user) { [weak self] result in
            switch result {
            case .success(_):
                self?.reloadDataPublisher.send()
            case .failure(let error):
                self?.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func loadProfileFields() {
        let builder = ProfileDataBuilder()
        
        ProfileFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    private func setValue(_ value: AnyObject?, for field: ProfileFieldType) {
        data[field.rawValue].data = value
    }
    
    private func getValue(for field: ProfileFieldType) -> AnyObject? {
        return data[field.rawValue].data
    }
    
    private func updateData(_ userDetails: UserDetails) {
        setValue(userDetails.firstName as AnyObject, for: .firstName)
        setValue(userDetails.lastName as AnyObject, for: .lastName)
        setValue(userDetails.email as AnyObject, for: .email)
        setValue(userDetails.phone as AnyObject, for: .phone)
        setValue(userDetails.organization as AnyObject, for: .organization)
        
        let state: CheckboxState = userDetails.hasAgreedToKeepData ? .checked : .unchecked
        setValue(state as AnyObject, for: .hasAgreedToKeepData)
        
        reloadDataPublisher.send()
    }
    
    private func getProfile() {
        APIManager.shared.getUserDetails { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let userDetails):
                strongSelf.userDetails = userDetails
                strongSelf.updateData(userDetails)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
    
    private func makeUserDetails() -> UserDetails? {
        guard
            let firstName = getValue(for: .firstName) as? String,
            let lastName = getValue(for: .lastName) as? String,
            let email = getValue(for: .email) as? String,
            let phone = getValue(for: .phone) as? String,
            let pin = userDetails?.pin,
            let organization = getValue(for: .organization) as? Organization,
            let hasAgreedToKeepData = getValue(for: .hasAgreedToKeepData) as? CheckboxState
        else {
            return nil
        }
        
        return UserDetails(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phone: phone,
            pin: pin,
            hasAgreedToKeepData: hasAgreedToKeepData == .checked,
            organization: organization
        )
    }
}
