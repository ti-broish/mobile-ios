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
    private let baseUrl = "https://d1tapi.dabulgaria.bg"
    #else
    private let baseUrl = "https://api.tibroish.bg"
    #endif
    
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
        
        if request.token.count > 0 {
            allHeaders["Authorization"] = "Bearer \(request.token)"
        }
        
        AF.request(
            url,
            method: request.method,
            parameters: request.parameters.compactMapValues({ $0 }),
            encoding: URLEncoding.default,
            headers: allHeaders
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

// MARK: -

extension APIClient {
    
    func getOrganizations(completion: APIResult<[Organization]>?) {
        let request = OrganizationsRequest()
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getCountries(token: String, completion: APIResult<[Country]>?) {
        let request = CountriesRequest(token: token)
        
        send(request) { result in
            completion?(result)
        }
    }
}

// MARK: - APNs Token
extension APIClient {
    
    func sendAPNsToken(token: String, completion: APIResult<BaseResponse>?) {
        let request = APNSTokenRequest(token: token)
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Violations
extension APIClient {
    
    func sendViolation(
        token: String,
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
            section: section,
            token: token
        )
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getViolation(token: String, id: String, _ completion: APIResult<Violation>?) {
        getViolations(token: token) { result in
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
    
    func getViolations(token: String, completion: APIResult<ViolationsResponse>?) {
        let request = GetViolationsRequest(token: token)
        
        send(request) { result in
            completion?(result)
        }
    }
    
}

// MARK: - Protocols
extension APIClient {
    
    func sendProtocol(token: String, section: Section, pictures: [String], completion: APIResult<SendProtocolResponse>?) {
        let request = SendProtocolRequest(section: section, pictures: pictures, token: token)
        
        send(request) { result in
            completion?(result)
        }
    }
    
    func getProtocol(token: String, id: String, completion: APIResult<Protocol>?) {
        getProtocols(token: token) { result in
            switch result {
            case .success(let protocols):
                guard let proto = protocols.filter({ $0.id == id }).first else {
                    completion?(.failure(.violationNotFound))
                    return
                }
                
                completion?(.success(proto))
            case .failure(let error):
                print(error)
                completion?(.failure(error))
            }
        }
    }
    
    func getProtocols(token: String, completion: APIResult<ProtocolsResponse>?) {
        let request = GetProtocolRequest(token: token)
        
        send(request) { result in
            completion?(result)
        }
    }
}
