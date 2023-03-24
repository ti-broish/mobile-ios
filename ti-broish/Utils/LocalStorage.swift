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
            userDefaults.removeObject(forKey: jwtStorageKey())
        }
        
        // MARK: - Private methods
        
        private func jwtStorageKey() -> String {
            return "\(userStorageKey)_jwt"
        }
    }
}
