//
//  RegistrationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.04.21.
//

import Foundation

final class RegistrationViewModel: BaseViewModel, CoordinatableViewModel {
    
    // MARK: - Public Methods
    
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
}
