//
//  Validator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.05.21.
//

import Foundation

struct Validator {
    
    func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String?) -> Bool {
        guard
            let password = password,
            password.trimmingCharacters(in: .whitespaces).count != 0
        else {
            return false
        }
        
        return password.count >= 6
    }
}
