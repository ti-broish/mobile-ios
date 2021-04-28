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

// MARK: - Parties
extension APIManager {
    
    func getParties(_ completion: APIResult<PartiesResponse>?) {
        apiClient.getParties(completion)
    }
    
}

// MARK: - Location
extension APIManager {
    
    func getElectionRegions(isAbroad: Bool, completion: APIResult<ElectionRegionsResponse>?) {
        apiClient.getElectionRegions(isAbroad: isAbroad, completion: completion)
    }
    
    func getTowns(
        country: Country,
        electionRegion: ElectionRegion? = nil,
        municipality: Municipality,
        completion: APIResult<TownsResponse>?
    ) {
        apiClient.getTowns(
            country: country,
            electionRegion: electionRegion,
            municipality: municipality,
            completion: completion
        )
    }
    
}

// MARK: - Sections
extension APIManager {
    
    func getSections(town: Town, region: Region? = nil, completion: APIResult<SectionsResponse>?) {
        apiClient.getSections(town: town, region: region, completion: completion)
    }
    
}

// MARK: - Upload Photo
extension APIManager {
    
    func uploadPhoto(_ photo: Photo, completion: APIResult<UploadPhoto>?) {
        apiClient.uploadPhoto(photo, completion: completion)
    }
    
}

// MARK: - Violations
extension APIManager {
    
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        _ completion: APIResult<SendViolationResponse>?
    ) {
        apiClient.sendViolation(
            town: town,
            pictures: pictures,
            description: description,
            section: section,
            completion: completion
        )
    }
    
    func getViolation(id: String, _ completion: APIResult<Violation>?) {
        apiClient.getViolation(id: id, completion)
    }
    
    func getViolations(_ completion: APIResult<ViolationsResponse>?) {
        apiClient.getViolations(completion)
    }
    
}

// MARK: Protocols
extension APIManager {
    
    func sendProtocol(section: Section, pictures: [String], _ completion: APIResult<SendProtocolResponse>?) {
        apiClient.sendProtocol(section: section, pictures: pictures, completion: completion)
    }
    
    func getProtocol(id: String, _ completion: APIResult<Protocol>?) {
        apiClient.getProtocol(id: id, completion: completion)
    }
    
    func getProtocols(_ completion: APIResult<ProtocolsResponse>?) {
        apiClient.getProtocols(completion)
    }
    
}
