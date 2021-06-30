//
//  ProfileViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation
import Firebase
import Combine

final class ProfileViewModel: BaseViewModel, CoordinatableViewModel {
    
    private var userDetails: UserDetails?
    
    let savePublisher = PassthroughSubject<APIError?, Never>()
    let deletePublisher = PassthroughSubject<Void, Never>()
    
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
            NotificationCenter.default.post(name: NSNotification.Name.forceLogout, object: nil)
            return
        }

        guard let userDetails = makeUserDetails() else {
            print("failed to make user details")
            return
        }

        loadingPublisher.send(true)
        let user = User(firebaseUid: uid, userDetails: userDetails)
        
        APIManager.shared.updateUserDetails(user) { [weak self] result in
            switch result {
            case .success(_):
                self?.savePublisher.send(nil)
            case .failure(let error):
                self?.savePublisher.send(error)
            }
        }
    }
    
    func deleteProfile() {
        loadingPublisher.send(true)
        APIManager.shared.deleteUser { [weak self] _ in
            self?.deletePublisher.send()
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
        
        if let organization = userDetails.organization {
            let searchItem = SearchItem(
                id: organization.id,
                name: organization.name,
                code: "",
                type: .organization,
                data: organization as AnyObject
            )
            
            setFieldValue(searchItem as AnyObject, forFieldAt: indexFor(field: .organization))
        }
        
        let state: CheckboxState = userDetails.hasAgreedToKeepData ? .checked : .unchecked
        setFieldValue(state as AnyObject, forFieldAt: indexFor(field: .hasAgreedToKeepData))
        
        reloadDataPublisher.send(nil)
    }
    
    private func getProfile() {
        loadingPublisher.send(true)
        APIManager.shared.getUserDetails { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let userDetails):
                strongSelf.userDetails = userDetails
                strongSelf.updateData(userDetails)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
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
            let organization = dataForSendField(type: .organization) as? Organization,
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
