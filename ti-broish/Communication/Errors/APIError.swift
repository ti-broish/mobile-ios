//
//  APIError.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

enum APIResponseErrorType: String, Codable {
    
    case BadRequestException
    case ConflictException
    case UnauthorizedException
}

struct APIResponseError: Codable {
    
    let error: String
    let errorType: APIResponseErrorType
    let message: String
    let statusCode: Int
}

struct APIResponseErrors: Codable {
    
    let error: String
    let errorType: APIResponseErrorType
    let message: [String]
    let statusCode: Int
    
    var firstError: String? {
        if let message = message.first, message.count > 1 {
            return message
        } else {
            var text: String? = nil
            
            message.forEach { item in
                if let c = item.first {
                    text?.append(c)
                }
            }
            
            return text
        }
    }
    
    static func make(from responseError: APIResponseError) -> APIResponseErrors {
        return APIResponseErrors(
            error: responseError.error,
            errorType: responseError.errorType,
            message: [responseError.message],
            statusCode: responseError.statusCode
        )
    }
}

enum APIError: Error {
    
    case unknown
    
    /// Failed to create a valid `URL` from `APIRequest`'s baseUrl.
    case invalidBaseUrl

    /// Api Request failed with an underlying error.
    case requestFailed(error: Error)
    
    /// Api Request failed with an underlying errors.
    case requestFailed(responseErrors: APIResponseErrors)
    
    /// Api response no data
    case invalidResponseData

    // MARK: - Encoding

    /// JSON serialization failed with an underlying system error during the encoding process.
    case jsonEncodingFailed(error: Error)
    ///
    case jsonDecodingFailed(error: Error)
    /// Parameter serialization failed with an underlying system error during the encoding process.
    case parameterEncodingFailed(error: Error)
    /// The `URLRequest` did not have a `URL` to encode.
    case missingURL

    // MARK: - Authorization

    /// Authorization token is empty
    case invalidAuthorizationToken
    
    /// Violation not found
    case violationNotFound
    
    /// Protocol not found
    case protocolNotFound
}
