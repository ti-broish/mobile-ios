//
//  ApiManager.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

public typealias APIResult<T> = Swift.Result<T, APIError>
public typealias APIResultHandler<T: Decodable> = (APIResult<T>) -> Void

class APIManager {
    
    // MARK: Properites
    
    static let shared = APIManager()
    
    private let apiClient: APIClientProtocol
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
    
}
