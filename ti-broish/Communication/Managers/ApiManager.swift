//
//  ApiManager.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Alamofire

public typealias APIResult<T> = Swift.Result<T, APIError>
public typealias APIResultHandler<T: Decodable> = (APIResult<T>) -> Void

class ApiManager {
    
    // MARK: Private Methods
    
    private static func send<T: Decodable>(
        _ request: BaseHttpRequestProtocol,
        _ completion: @escaping APIResultHandler<T>
    ) {
        guard let url = try? request.url.asURL() else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = request.decodingStrategy
        
        AF.request(
            url,
            method: request.method,
            parameters: request.parameters,
            encoding: request.encoding,
            headers: request.allHeaders
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

// MARK: Requests
extension ApiManager {
    
}
