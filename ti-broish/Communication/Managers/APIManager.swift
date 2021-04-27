//
//  ApiManager.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

public typealias APIResult<T: Decodable> = (Swift.Result<T, APIError>) -> Void

class APIManager {
    
    // MARK: Properites
    
    static let shared = APIManager()
    
    private let apiClient: APIClient
    private let firebaseClient: FirebaseClient
    
    // MARK: Initializers
    
    private init() {
        self.apiClient = APIClient()
        self.firebaseClient = FirebaseClient()
    }
    
}

// MARK: Requests
extension APIManager {
    
    func register() {
        firebaseClient.register()
    }
    
    func sendAPNsToken(_ token: String, completion: APIResult<BaseResponse>?) {
        apiClient.sendAPNsToken(token, completion: completion)
    }
    
}
