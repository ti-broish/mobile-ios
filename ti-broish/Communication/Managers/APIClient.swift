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
    
    private let baseUrl = ""
    
    // MARK: Private Methods
    
    private func send<T: Decodable>(
        _ request: RequestProvider,
        _ completion: @escaping APIResult<T>
    ) {
        let urlString = baseUrl.appending(request.path)
        guard let url = try? urlString.asURL() else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = request.decodingStrategy
        
        let allHeaders = request.additionalHeaders
        
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
    
}
