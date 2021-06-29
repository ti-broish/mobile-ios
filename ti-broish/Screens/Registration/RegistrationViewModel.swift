//
//  RegistrationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.04.21.
//

import Foundation

final class RegistrationViewModel: BaseViewModel, CoordinatableViewModel {
    
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
