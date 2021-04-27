//
//  APIClient.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Alamofire

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
            parameters: request.parameters,
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

// MARK: - Requests
extension APIClient {
    
    func sendAPNsToken(_ token: String, completion: APIResult<BaseResponse>?) {
        let request = SendAPNsToken(token: token)
        send(request) { result in
            completion?(result)
        }
    }
    
}
