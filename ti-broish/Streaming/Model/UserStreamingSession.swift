//
//  UserSession.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 31.03.21.
//

import Foundation

class UserStreamingSession {
    
    static let `default` = UserStreamingSession()
    
    private static let streamKey = "bg.tibroishlive.ios.streamKey"
    
    var streamInfo: UserStream? {
        get {
            return getJson(UserStream.self, forKey: UserStreamingSession.streamKey)
        }
        
        set {
            storeJson(newValue, forKey: UserStreamingSession.streamKey)
        }
    }
    
    func clearInfo() {
        UserDefaults.standard.removeObject(forKey: UserStreamingSession.streamKey)
    }
    
    private func storeJson<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let jsonData = try JSONEncoder.default.encode(value)
            UserDefaults.standard.set(jsonData, forKey: key)
        } catch {
            #if DEBUG
            print("\(String(describing: value)) can't be encoded.")
            #endif
        }
    }
    
    private func getJson<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let userJSON = UserDefaults.standard.data(forKey: key) {
            do {
                let user = try JSONDecoder.default.decode(type, from: userJSON)
                return user
            } catch {
                #if DEBUG
                print("Stored \(String(describing: type)) info can't be decoded.")
                #endif
            }
        }
        return nil
    }
    
}
