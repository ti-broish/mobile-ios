//
//  ResetPasswordViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 9.06.21.
//

import Foundation

final class ResetPasswordViewModel: BaseViewModel, CoordinatableViewModel {
    
    // MARK: - Public Methods
    
    override func loadDataFields() {
        let builder = ResetPasswordDataBuilder()
        
        ResetPasswordFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = ResetPasswordFieldType(rawValue: indexPath.row) else {
            return
        }
        
        setFieldValue(value, forFieldAt: field.rawValue)
    }
    
    func start() {
        loadDataFields()
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, FirebaseError>) -> (Void)) {
        APIManager.shared.resetPassword(email: email, completion: completion)
    }
}
