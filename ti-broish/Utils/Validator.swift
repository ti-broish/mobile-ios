//
//  Validator.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.05.21.
//

import Foundation

struct Validator {
    
    func validate(email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: email)
    }
    
    func validate(password: String?) -> Bool {
        guard
            let password = password,
            password.trimmingCharacters(in: .whitespaces).count != 0
        else {
            return false
        }
        
        return password.count >= 6
    }
    
    func validate(phone: String?) -> Bool {
        guard let phone = phone else {
            return false
        }
        
        let regEx = "^[+]{0,1}\\d+$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: phone)
    }
    
    func validate(name: String?) -> Bool {
        guard let name = name else {
            return false
        }
        
        return name.count > 0
    }
    
    func validate(pin: String?) -> Bool {
        guard let pin = pin else {
            return false
        }
        
        let regEx = "^[0-9]{4}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return predicate.evaluate(with: pin)
    }
    
    func validate(organization: Organization?) -> Bool {
        guard let organization = organization else {
            return false
        }
        
        return organization.id != 0 && organization.name.count > 0;
    }
    
    func validate(hasAdulthood: CheckboxState?) -> Bool {
        guard let hasAdulthood = hasAdulthood else {
            return false
        }
        
        return hasAdulthood == .checked
    }
    
    func validateRegistration(fields: [InputFieldConfig]) -> [String] {
        var errors = [String]()
        
        if !validate(name: fields[RegistrationFieldType.firstName.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidFirstName)
        }
        
        if !validate(name: fields[RegistrationFieldType.lastName.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidLastName)
        }
        
        if !validate(email: fields[RegistrationFieldType.email.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidEmail)
        }
        
        if !validate(phone: fields[RegistrationFieldType.phone.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidPhone)
        }
        
        if !validate(pin: fields[RegistrationFieldType.pin.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidPin)
        }
        
        if fields[RegistrationFieldType.organization.rawValue].data == nil {
            errors.append(LocalizedStrings.Errors.invalidOrganization)
        } else {
            if let item = fields[RegistrationFieldType.organization.rawValue].data as? SearchItem,
               !validate(organization: item.data as? Organization)
            {
                errors.append(LocalizedStrings.Errors.invalidOrganization)
            }
        }
        
        if !validate(password: fields[RegistrationFieldType.password.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.wrongPassword)
        }
        
        if !validate(password: fields[RegistrationFieldType.confirmPassword.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.wrongConfirmPassword)
        } else {
            if let password = fields[RegistrationFieldType.password.rawValue].data as? String,
               let confirmPassword = fields[RegistrationFieldType.confirmPassword.rawValue].data as? String,
               password != confirmPassword
            {
                errors.append(LocalizedStrings.Errors.wrongConfirmPassword)
            }
        }
        
        if !validate(hasAdulthood: fields[RegistrationFieldType.hasAdulthood.rawValue].data as? CheckboxState) {
            errors.append(LocalizedStrings.Errors.invalidHasAdulthood)
        }
        
        return errors
    }
    
    func validateProfile(fields: [InputFieldConfig]) -> [String] {
        var errors = [String]()
        
        if !validate(name: fields[ProfileFieldType.firstName.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidFirstName)
        }
        
        if !validate(name: fields[ProfileFieldType.lastName.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidLastName)
        }
        
        if !validate(phone: fields[ProfileFieldType.phone.rawValue].data as? String) {
            errors.append(LocalizedStrings.Errors.invalidPhone)
        }
        
        return errors
    }
}
