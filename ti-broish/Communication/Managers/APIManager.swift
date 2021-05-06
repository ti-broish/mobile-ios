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
    
    func login(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        firebaseClient.login(email: email, password: password, completion: completion)
    }
    
    func register() {
        firebaseClient.register()
    }
}

// MARK: - API calls

extension APIManager {
    
    func getOrganizations(completion: APIResult<[Organization]>?) {
        apiClient.getOrganizations(completion: completion)
    }
    
    func getCountries(token: String, completion: APIResult<[Country]>?) {
        apiClient.getCountries(token: token, completion: completion)
    }
}

// MARK: - APNs Token
extension APIManager {
    
    func sendAPNsToken(token: String, completion: APIResult<BaseResponse>?) {
        apiClient.sendAPNsToken(token: token, completion: completion)
    }
}

// MARK: - Violations
extension APIManager {
    
    func sendViolation(
        token: String,
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        _ completion: APIResult<SendViolationResponse>?
    ) {
        apiClient.sendViolation(
            token: token,
            town: town,
            pictures: pictures,
            description: description,
            section: section,
            completion: completion
        )
    }
    
    func getViolation(token: String,id: String, _ completion: APIResult<Violation>?) {
        apiClient.getViolation(token: token, id: id, completion)
    }
    
    func getViolations(token: String, completion: APIResult<ViolationsResponse>?) {
        apiClient.getViolations(token: token, completion: completion)
    }
    
}

// MARK: Protocols
extension APIManager {
    
    func sendProtocol(token: String, section: Section, pictures: [String], _ completion: APIResult<SendProtocolResponse>?) {
        apiClient.sendProtocol(token: token, section: section, pictures: pictures, completion: completion)
    }
    
    func getProtocol(token: String, id: String, _ completion: APIResult<Protocol>?) {
        apiClient.getProtocol(token: token, id: id, completion: completion)
    }
    
    func getProtocols(token: String, completion: APIResult<ProtocolsResponse>?) {
        apiClient.getProtocols(token: token, completion: completion)
    }
    
}
