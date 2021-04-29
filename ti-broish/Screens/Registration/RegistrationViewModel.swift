//
//  RegistrationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.04.21.
//

import Foundation

final class RegistrationViewModel: CoordinatableViewModel {
    
    private (set) var inputFieldsConfigs = [InputFieldConfig]()
    
    init() {
        start()
    }
    
    // MARK: - Public Methods
    
    func start() {
        loadRegistrationFields()
    }
    
    // MARK: - Private methods
    
    private func loadRegistrationFields() {
        let builder = RegistrationDataBuilder()
        
        RegistrationFieldType.allCases.forEach {
            inputFieldsConfigs.append(builder.makeConfigForRegistrationFieldType(type: $0))
        }
    }
}
