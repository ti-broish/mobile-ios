//
//  BaseHttpRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation
import Alamofire

protocol BaseHttpRequestProtocol {
    
    var url: String { get }
    
    var method: HTTPMethod { get }
    
    var allHeaders: HTTPHeaders { get }
    
    var encoding: ParameterEncoding { get }
    
    var parameters: [String: Any] { get }
    
    var decodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
    
}

class BaseHttpRequest: BaseHttpRequestProtocol {
    
    // MARK: Properites
    
    private let baseUrl = ""
    
    final var url: String {
        baseUrl.appending(path)
    }
    
    var path: String {
        ""
    }
    
    var method: HTTPMethod {
        .get
    }
    
    final var allHeaders: HTTPHeaders {
        [:]
    }
    
    var additionalHeaders: HTTPHeaders {
        [:]
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var parameters: [String: Any] {
        [:]
    }
    
    var decodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .convertFromSnakeCase
    }
    
}
