//
//  APIClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Alamofire

typealias HTTPMethod = Alamofire.HTTPMethod

protocol APIClientInterface {
    
    // MARK: - User
    
    func createUser(_ user: User, completion: APIResult<BaseResponse>?)
    func getUserDetails(completion: APIResult<UserDetails>?)
    func updateUserDetails(_ user: User, completion: APIResult<BaseResponse>?)
    func deleteUser(completion: APIResult<UserDetails>?)
    
    func getOrganizations(completion: APIResult<OrganizationsResponse>?)
    func sendAPNsToken(completion: APIResult<BaseResponse>?)
    func getParties(_ completion: APIResult<PartiesResponse>?)
    
    // MARK: - Location
    func getCountries(isAbroad: Bool, completion: APIResult<CountriesResponse>?)
    func getElectionRegions(isAbroad: Bool, completion: APIResult<ElectionRegionsResponse>?)
        
    func getTowns(
        country: Country,
        electionRegion: ElectionRegion?,
        municipality: Municipality,
        completion: APIResult<TownsResponse>?
    )
    
    func getSections(town: Town, region: Region?, completion: APIResult<SectionsResponse>?)

    // MARK: - Upload Photo
    func uploadPhoto(_ photo: Photo, completion: APIResult<UploadPhoto>?)

    // MARK: - Violations
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        completion: APIResult<SendViolationResponse>?
    )
    
    func getViolation(id: String, _ completion: APIResult<Violation>?)
    func getViolations(completion: APIResult<ViolationsResponse>?)
    
    // MARK: - Protocols
    func sendProtocol(section: Section, pictures: [String], completion: APIResult<SendProtocolResponse>?)
    func getProtocol(id: String, completion: APIResult<Protocol>?)
    func getProtocols(completion: APIResult<ProtocolsResponse>?)
}

final class APIClient {
    
    // MARK: Properties
    
    #if InDebug
    private let baseUrl = "https://d1tapi.dabulgaria.bg"
    #else
    private let baseUrl = "https://api.tibroish.bg"
    #endif
    
    private let requestInterceptor: RequestInterceptor
    
    init() {
        self.requestInterceptor = RequestInterceptor(storage: LocalStorage(), host: baseUrl)
    }
    
    // MARK: Private Methods
    
    private func send<T: Decodable>(
        _ request: RequestProvider,
        _ completion: @escaping APIResult<T>
    ) {
        let urlString = baseUrl.appending(request.path)
        guard let url = try? urlString.asURL() else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = request.decodingStrategy

        AF.request(
            url,
            method: request.method,
            parameters: request.parameters.compactMapValues({ $0 }),
            encoding: URLEncoding.default,
            headers: request.additionalHeaders,
            interceptor: requestInterceptor
        )
        .responseDecodable(of: T.self, decoder: decoder) { response in
            DispatchQueue.main.async {
                let mappedResponse = response.mapError { (error) -> APIError in
                    APIError.requestFailed(error: error)
                }
                
                completion(mappedResponse.result)
            }
        }
    }
}

// MARK: - APIClientInterface

extension APIClient: APIClientInterface {
    
    // MARK: - User
    
    func createUser(_ user: User, completion: APIResult<BaseResponse>?) {
        let request = CreateUserRequest(user: user)
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getUserDetails(completion: APIResult<UserDetails>?) {
        let request = GetUserDetailsRequest()
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func updateUserDetails(_ user: User, completion: APIResult<BaseResponse>?) {
        let request = UpdateUserDetailsRequest(user: user)
    
        send(request) { result in
            completion?(result)
        }
    }
    
    func deleteUser(completion: APIResult<UserDetails>?) {
        let request = DeleteUserRequest()
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getOrganizations(completion: APIResult<OrganizationsResponse>?) {
        let request = OrganizationsRequest()
        
        send(request) { result in
            completion?(result)
        }
    }
    
    // MARK: - APNs Token
    
    func sendAPNsToken(completion: APIResult<BaseResponse>?) {
        let request = APNSTokenRequest()
        send(request) { result in
            completion?(result)
        }
    }

    // MARK: - Parties
    
    func getParties(_ completion: APIResult<PartiesResponse>?) {
        let request = GetPartiesRequest()
        send(request) { result in
            completion?(result)
        }
    }

    // MARK: - Location
    
    func getCountries(isAbroad: Bool, completion: APIResult<CountriesResponse>?) {
        let request = GetCountriesRequest()
        send(request) { (result: Result<CountriesResponse, APIError>) in
            switch result {
            case .success(let countries):
                var filteredCountries = countries.filter({ $0.isAbroad == isAbroad })
                filteredCountries.sort(by: { $0.name < $1.name })
                completion?(.success(filteredCountries))
            case .failure(let error):
                completion?(.failure(.requestFailed(error: error)))
            }
        }
    }

    func getElectionRegions(isAbroad: Bool, completion: APIResult<ElectionRegionsResponse>?) {
        let request = GetElectionRegionsRequest()
        send(request) { (result: Result<ElectionRegionsResponse, APIError>) in
            switch result {
            case .success(var regions):
                regions.sort(by: { $0.code < $1.code })
                completion?(.success(regions))
            case .failure(let error):
                completion?(.failure(.requestFailed(error: error)))
            }
        }
    }
    
    func getTowns(
        country: Country,
        electionRegion: ElectionRegion? = nil,
        municipality: Municipality,
        completion: APIResult<TownsResponse>?
    ) {
        let request = GetTownsRequest(country: country, electionRegion: electionRegion, municipality: municipality)
        send(request) { result in
            completion?(result)
        }
    }
    
    func getSections(town: Town, region: Region? = nil, completion: APIResult<SectionsResponse>?) {
        let request = GetSectionsRequest(town: town, region: region)
        send(request) { (result: Result<SectionsResponse, APIError>) in
            switch result {
            case .success(var sections):
                sections.sort(by: { $0.code < $1.code })
                completion?(.success(sections))
            case .failure(let error):
                completion?(.failure(.requestFailed(error: error)))
            }
        }
    }

    // MARK: - Upload Photo

    func uploadPhoto(_ photo: Photo, completion: APIResult<UploadPhoto>?) {
        let request = UploadPhotoRequest(photo: photo)
        send(request) { result in
            completion?(result)
        }
    }
    
    // MARK: - Violations
    
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        completion: APIResult<SendViolationResponse>?
    ) {
        let request = SendViolationRequest(
            town: town,
            pictures: pictures,
            description: description,
            section: section
        )
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getViolation(id: String, _ completion: APIResult<Violation>?) {
        getViolations() { result in
            switch result {
            case .success(let violations):
                guard let violation = violations.filter({ $0.id == id }).first else {
                    completion?(.failure(.violationNotFound))
                    return
                }
                
                completion?(.success(violation))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func getViolations(completion: APIResult<ViolationsResponse>?) {
        let request = GetViolationsRequest()
        
        send(request) { result in
            completion?(result)
        }
    }

    // MARK: - Protocols
    
    func sendProtocol(section: Section, pictures: [String], completion: APIResult<SendProtocolResponse>?) {
        let request = SendProtocolRequest(section: section, pictures: pictures)
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getProtocol(id: String, completion: APIResult<Protocol>?) {
        getProtocols() { result in
            switch result {
            case .success(let protocols):
                guard let proto = protocols.filter({ $0.id == id }).first else {
                    completion?(.failure(.protocolNotFound))
                    return
                }
                
                completion?(.success(proto))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func getProtocols(completion: APIResult<ProtocolsResponse>?) {
        let request = GetProtocolRequest()
        
        send(request) { result in
            completion?(result)
        }
    }
}
