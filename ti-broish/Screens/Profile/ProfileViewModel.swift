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
    
    override func loadDataFields() {
        let builder = ProfileDataBuilder()
        
        ProfileFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = ProfileFieldType(rawValue: indexPath.row) else {
            return
        }
        
        setFieldValue(value, forFieldAt: field.rawValue)
    }
    
    func start() {
        loadDataFields()
        getProfile()
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
    
    private func indexFor(field: ProfileFieldType) -> Int {
        return field.rawValue
    }
    
    private func updateData(_ userDetails: UserDetails) {
        setFieldValue(userDetails.firstName as AnyObject, forFieldAt: indexFor(field: .firstName))
        setFieldValue(userDetails.lastName as AnyObject, forFieldAt: indexFor(field: .lastName))
        setFieldValue(userDetails.email as AnyObject, forFieldAt: indexFor(field: .email))
        setFieldValue(userDetails.phone as AnyObject, forFieldAt: indexFor(field: .phone))
        setFieldValue(userDetails.organization as AnyObject, forFieldAt: indexFor(field: .organization))
        
        let state: CheckboxState = userDetails.hasAgreedToKeepData ? .checked : .unchecked
        setFieldValue(state as AnyObject, forFieldAt: indexFor(field: .hasAgreedToKeepData))
        
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
            let firstName = getFieldValue(forFieldAt: indexFor(field: .firstName)) as? String,
            let lastName = getFieldValue(forFieldAt: indexFor(field: .lastName)) as? String,
            let email = getFieldValue(forFieldAt: indexFor(field: .email)) as? String,
            let phone = getFieldValue(forFieldAt: indexFor(field: .phone)) as? String,
            let pin = userDetails?.pin,
            let organization = getFieldValue(forFieldAt: indexFor(field: .organization)) as? Organization,
            let hasAgreedToKeepData = getFieldValue(forFieldAt: indexFor(field: .hasAgreedToKeepData)) as? CheckboxState
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
