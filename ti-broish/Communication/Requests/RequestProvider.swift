//
//  RequestProvider.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Alamofire

protocol RequestProvider {
    
    var path: String { get }
    
    var method: HTTPMethod { get }
    
    var additionalHeaders: HTTPHeaders { get }
    
    var encoding: ParameterEncoding { get }
    
    var parameters: [String: Any] { get }
    
    var decodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    
}

extension RequestProvider {
    
    // MARK: Properites
    
    var method: HTTPMethod {
        .get
    }
    
    var additionalHeaders: HTTPHeaders {
        [:]
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .convertFromSnakeCase
    }
    
}
