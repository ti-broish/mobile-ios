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
    
    func register(email: String, password: String, completion: @escaping (Result<String, FirebaseError>) -> Void) {
        firebaseClient.register(email: email, password: password, completion: completion)
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        firebaseClient.resetPassword(email: email, completion: completion)
    }
    
    func refreshToken(completion: @escaping (Result<String, FirebaseError>) -> Void) {
        firebaseClient.refreshToken(completion: completion)
    }
    
    func sendEmailVerification(completion: @escaping (Result<Void, FirebaseError>) -> Void) {
        firebaseClient.sendEmailVerification(completion: completion)
    }
    
    func getAppCheckToken(forcingRefresh: Bool = false, completion: @escaping (Result<String, FirebaseAppCheckError>) -> Void) {
        firebaseClient.getAppCheckToken(forcingRefresh: forcingRefresh, completion: completion)
    }
}

// MARK: - API calls

extension APIManager: APIClientInterface {
    
    // MARK: - User
    
    func createUser(_ user: User, completion: APIResult<BaseResponse>?) {
        apiClient.createUser(user, completion: completion)
    }
    
    func getUserDetails(completion: APIResult<UserDetails>?) {
        apiClient.getUserDetails(completion: completion)
    }
    
    func updateUserDetails(_ user: User, completion: APIResult<BaseResponse>?) {
        apiClient.updateUserDetails(user, completion: completion)
    }
    
    func deleteUser(completion: APIResult<BaseResponse>?) {
        apiClient.deleteUser(completion: completion)
    }
    
    func getOrganizations(completion: APIResult<OrganizationsResponse>?) {
        apiClient.getOrganizations(completion: completion)
    }
    
    func sendAPNsToken(completion: APIResult<BaseResponse>?) {
        apiClient.sendAPNsToken(completion: completion)
    }

    func getParties(_ completion: APIResult<PartiesResponse>?) {
        apiClient.getParties(completion)
    }
    
    // MARK: - Location
    
    func getCountries(isAbroad: Bool, completion: APIResult<CountriesResponse>?) {
        apiClient.getCountries(isAbroad: isAbroad, completion: completion)
    }
    
    func getElectionRegions(isAbroad: Bool, completion: APIResult<ElectionRegionsResponse>?) {
        apiClient.getElectionRegions(isAbroad: isAbroad, completion: completion)
    }
    
    func getTowns(
        country: Country,
        electionRegion: ElectionRegion? = nil,
        municipality: Municipality? = nil,
        completion: APIResult<TownsResponse>?
    ) {
        apiClient.getTowns(
            country: country,
            electionRegion: electionRegion,
            municipality: municipality,
            completion: completion
        )
    }

    // MARK: - Sections
    
    func getSections(town: Town, cityRegion: CityRegion? = nil, completion: APIResult<SectionsResponse>?) {
        apiClient.getSections(town: town, cityRegion: cityRegion, completion: completion)
    }
    
    // MARK: - Upload Photo
    
    func uploadPhoto(_ photo: Photo, completion: APIResult<UploadPhoto>?) {
        apiClient.uploadPhoto(photo, completion: completion)
    }
    
    // MARK: - Violations
    
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        contacts: ViolationContacts,
        completion: APIResult<SendViolationResponse>?
    ) {
        apiClient.sendViolation(
            town: town,
            pictures: pictures,
            description: description,
            section: section,
            contacts: contacts, 
            completion: completion
        )
    }
    
    func getViolation(id: String, _ completion: APIResult<Violation>?) {
        apiClient.getViolation(id: id, completion)
    }
    
    func getViolations(completion: APIResult<ViolationsResponse>?) {
        apiClient.getViolations(completion: completion)
    }

    // MARK: - Protocols
    
    func sendProtocol(section: Section, pictures: [String], completion: APIResult<SendProtocolResponse>?) {
        apiClient.sendProtocol(section: section, pictures: pictures, completion: completion)
    }
    
    func getProtocol(id: String, completion: APIResult<Protocol>?) {
        apiClient.getProtocol(id: id, completion: completion)
    }
    
    func getProtocols(completion: APIResult<ProtocolsResponse>?) {
        apiClient.getProtocols(completion: completion)
    }
    
    // MARK: - Live
    
    func startStream(section: Section, completion: APIResult<StreamResponse>?) {
        apiClient.startStream(section: section, completion: completion)
    }
    
    // MARK: - Checkin
    
    func sendCheckin(section: Section, completion: APIResult<BaseResponse>?) {
        apiClient.sendCheckin(section: section, completion: completion)
    }
}
