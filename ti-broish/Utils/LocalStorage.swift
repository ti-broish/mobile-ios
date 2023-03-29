//
//  LocalStorage.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.05.21.
//

import Foundation

struct LocalStorage {

    struct Login {
        
        private let userDefaults: UserDefaults
        
        private var storageKey: String {
            return "emailLocalStorageKey"
        }
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
        
        func getEmail() -> String? {
            guard let email = userDefaults.stringValue(forKey: storageKey) else {
                return nil
            }
            
            return email
        }
        
        func save(email: String) {
            LocalStorage.Protocols().reset()
            LocalStorage.Violations().reset()
            
            userDefaults.set(email, forKey: storageKey)
        }
    }
    
    struct User {
        
        private let userDefaults: UserDefaults
        
        private var userStorageKey: String {
            return "userLocalStorageKey"
        }

        var isLoggedIn: Bool {
            guard let token = getJwt() else {
                return false
            }
            
            return token.count > 0
        }
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
        
        func getJwt() -> String? {
            guard let jwt = userDefaults.stringValue(forKey: jwtStorageKey()) else {
                return nil
            }
            
            return jwt
        }
        
        func setJwt(_ jwt: String) {
            userDefaults.set(jwt, forKey: jwtStorageKey())
        }
        
        func reset() {
            LocalStorage.Protocols().reset()
            LocalStorage.Violations().reset()
            
            userDefaults.removeObject(forKey: jwtStorageKey())
        }
        
        // MARK: - Private methods
        
        private func jwtStorageKey() -> String {
            return "\(userStorageKey)_jwt"
        }
    }
    
    struct AppCheck {
        private let userDefaults: UserDefaults
        
        private var tokenStorageKey: String {
            return "appCheckTokenLocalStorageKey"
        }
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
        
        func getToken() -> String? {
            guard let token = userDefaults.stringValue(forKey: tokenStorageKey) else {
                return nil
            }
            
            return token
        }
        
        func setToken(_ token: String) {
            userDefaults.set(token, forKey: tokenStorageKey)
        }
        
        func reset() {
            userDefaults.removeObject(forKey: tokenStorageKey)
        }
    }
    
    struct Protocols {
        private let userDefaults: UserDefaults
        
        private var storageKey: String {
            return "protocolsLocalStorageKey"
        }
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
        
        func getProtocols() -> [SendProtocolResponse] {
            guard let data = userDefaults.object(forKey: storageKey) as? Data else {
                return []
            }
            
            guard let protocols = try? JSONDecoder().decode([SendProtocolResponse].self, from: data) else {
                return []
            }
            
            return protocols
        }
        
        func storeProtocol(_ protocolResponse: SendProtocolResponse) {
            var protocols = getProtocols()
            
            if protocols.first(where: { $0.id == protocolResponse.id }) == nil {
                protocols.append(protocolResponse)
                
                if let encodedProtocols = try? JSONEncoder().encode(protocols) {
                    userDefaults.setValue(encodedProtocols, forKey: storageKey)
                }
            }
        }
        
        func reset() {
            userDefaults.removeObject(forKey: storageKey)
        }
    }
    
    struct Violations {
        private let userDefaults: UserDefaults
        
        private var storageKey: String {
            return "violationsLocalStorageKey"
        }
        
        init(userDefaults: UserDefaults = UserDefaults.standard) {
            self.userDefaults = userDefaults
        }
        
        func getViolations() -> [SendViolationResponse] {
            guard let data = userDefaults.object(forKey: storageKey) as? Data else {
                return []
            }
            
            guard let violations = try? JSONDecoder().decode([SendViolationResponse].self, from: data) else {
                return []
            }
            
            return violations
        }
        
        func storeViolation(_ violationResponse: SendViolationResponse) {
            var violations = getViolations()
            
            if violations.first(where: { $0.id == violationResponse.id }) == nil {
                violations.append(violationResponse)
                
                if let encodedViolations = try? JSONEncoder().encode(violations) {
                    userDefaults.setValue(encodedViolations, forKey: storageKey)
                }
            }
        }
        
        func reset() {
            userDefaults.removeObject(forKey: storageKey)
        }
    }
}
