//
//  APIClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Alamofire

typealias HTTPMethod = Alamofire.HTTPMethod

class APIClient {
    
    // MARK: Properties
    
    #if InDebug
    private let baseUrl = "https://api.tibroish.bg/"
    #else
    private let baseUrl = "https://d1tapi.dabulgaria.bg/"
    #endif
    
    private var jwt = ""
    
    // MARK: Private Methods
    
    private func send<T: Decodable>(
        _ request: RequestProvider,
        _ completion: @escaping APIResult<T>
    ) {
        let urlString = baseUrl.appending(request.path)
        guard let url = try? urlString.asURL() else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = request.decodingStrategy
        
        var allHeaders = request.additionalHeaders
        defaultHeaders.forEach( { allHeaders.add($0) })
        
        AF.request(
            url,
            method: request.method,
            parameters: request.parameters.compactMapValues({ $0 }),
            encoding: request.encoding,
            headers: allHeaders
        )
        .responseDecodable(of: T.self, decoder: decoder) { response in
            DispatchQueue.main.async {
                let mappedResponse = response
                    .mapError { (error) -> APIError in
                        APIError.requestFailed(error: error)
                    }
                completion(mappedResponse.result)
            }
        }
    }
    
    // MARK: Private Methods
    
    private var defaultHeaders: HTTPHeaders {
        ["Authorization" : "Bearer \(jwt)"]
    }
    
}

// MARK: - APNs Token
extension APIClient {
    
    func sendAPNsToken(_ token: String, completion: APIResult<BaseResponse>?) {
        let request = APNSTokenRequest(token: token)
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Parties
extension APIClient {
    
    func getParties(_ completion: APIResult<PartiesResponse>?) {
        let request = GetPartiesRequest()
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Location

extension APIClient {
    
    func getElectionRegions(isAbroad: Bool, completion: APIResult<ElectionRegionsResponse>?) {
        let request = GetElectionRegionsRequest()
        send(request) { result in
            completion?(result)
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
    
    func getCountries(isAbroad: Bool, completion: APIResult<CountriesResponse>?) {
        let request = GetCountriesRequest()
        send(request) { (result: Result<CountriesResponse, APIError>) in
            switch result {
            case .success(let countries):
                let filteredCountries = countries.filter({ $0.isAbroad == isAbroad })
                completion?(.success(filteredCountries))
            case .failure(let error):
                print(error)
                completion?(.failure(.requestFailed(error: error)))
            }
        }
    }
    
}

// MARK: - Sections
extension APIClient {
    
    func getSections(town: Town, region: Region? = nil, completion: APIResult<SectionsResponse>?) {
        let request = GetSectionsRequest(town: town, region: region)
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Upload Photo
extension APIClient {
    
    func uploadPhoto(_ photo: Photo, completion: APIResult<UploadPhoto>?) {
        let request = UploadPhotoRequest(photo: photo)
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Violations
extension APIClient {
    
    func sendViolation(
        town: Town,
        pictures: [String],
        description: String,
        section: Section?,
        completion: APIResult<SendViolationResponse>?
    ) {
        let request = SendViolationRequest(town: town, pictures: pictures, description: description, section: section)
        send(request) { result in
            completion?(result)
        }
    }
    
    func getViolation(id: String, _ completion: APIResult<Violation>?) {
        getViolations { result in
            switch result {
            case .success(let violations):
                guard let violation = violations.filter({ $0.id == id }).first else {
                    completion?(.failure(.violationNotFound))
                    return
                }
                
                completion?(.success(violation))
            case .failure(let error):
                print(error)
                completion?(.failure(error))
            }
        }
    }
    
    func getViolations(_ completion: APIResult<ViolationsResponse>?) {
        let request = GetViolationsRequest()
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Protocols
extension APIClient {
    
    func sendProtocol(section: Section, pictures: [String], completion: APIResult<SendProtocolResponse>?) {
        let request = SendProtocolRequest(section: section, pictures: pictures)
        send(request) { result in
            completion?(result)
        }
    }
    
    func getProtocol(id: String, completion: APIResult<Protocol>?) {
        getProtocols { result in
            switch result {
            case .success(let protocols):
                guard let proto = protocols.filter({ $0.id == id }).first else {
                    completion?(.failure(.protocolNotFound))
                    return
                }
                
                completion?(.success(proto))
            case .failure(let error):
                print(error)
                completion?(.failure(error))
            }
        }
    }
    
    func getProtocols(_ completion: APIResult<ProtocolsResponse>?) {
        let request = GetProtocolRequest()
        send(request) { result in
            completion?(result)
        }
    }
    
}
