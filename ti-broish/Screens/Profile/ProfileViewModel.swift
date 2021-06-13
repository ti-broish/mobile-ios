//
//  ProfileViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class ProfileViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var data = [InputFieldConfig]()
    
    override init() {
        super.init()
        loadProfileFields()
    }

    func start() {
        
        getProfile()
    }
    
    func updateValue(_ value: AnyObject?, at indexPath: IndexPath) {
        data[indexPath.row].data = value
    }
    
    // MARK: - Private methods
    
    private func loadProfileFields() {
        let builder = ProfileDataBuilder()
        
        ProfileFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    private func updateData(_ userDetails: UserDetails) {
        data[0].data = userDetails.firstName as AnyObject
        data[1].data = userDetails.lastName as AnyObject
        data[2].data = userDetails.email as AnyObject
        data[3].data = userDetails.phone as AnyObject
        data[4].data = userDetails.organization as AnyObject
        
        let state: CheckboxState = userDetails.hasAgreedToKeepData ? .checked : .unchecked
        data[5].data = state as AnyObject
        
        reloadDataPublisher.send()
    }
    
    private func getProfile() {
        APIManager.shared.getUserDetails { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let profile):
                strongSelf.updateData(profile)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
}
