//
//  RegistrationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.04.21.
//

import Foundation

final class RegistrationViewModel: CoordinatableViewModel {
    
    private (set) var data = [InputFieldData]()
    
    init() {
        start()
    }
    
    // MARK: - Public Methods
    
    func start() {
        loadRegistrationFields()
    }
    
    func updateValue(_ value: AnyObject?, at indexPath: IndexPath) {
        data[indexPath.row].data = value
    }
    
    // MARK: - Private methods
    
    private func loadRegistrationFields() {
        let builder = RegistrationDataBuilder()
        
        RegistrationFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
}
