//
//  ApiManager.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

typealias APIResult<T: Decodable> = (Swift.Result<T, APIError>) -> Void

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

// MARK: - Firebase
extension APIManager {
    
    func register() {
        firebaseClient.register()
    }
    
}

// MARK: - APNs Token
extension APIManager {
    
    func sendAPNsToken(_ token: String, completion: APIResult<BaseResponse>?) {
        apiClient.sendAPNsToken(token, completion: completion)
    }
    
}

// MARK: - Violations
extension APIManager {
    
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        completion: APIResult<SendViolationResponse>?
    ) {
        apiClient.sendViolation(
            town: town,
            pictures: pictures,
            description: description,
            section: section,
            completion: completion
        )
    }
    
}
