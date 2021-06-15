//
//  APIError.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

enum APIError: Error {
    
    case unknown
    
    /// Failed to create a valid `URL` from `APIRequest`'s baseUrl.
    case invalidBaseUrl

    /// Api Request failed with an underlying error.
    case requestFailed(error: Error)
    
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
    
    /// Protocol  not found
    case protocolNotFound
}

enum APIResponseErrorType: String, Codable {
    
    case BadRequestException
}

struct APIResponseError: Codable {
    
    let error: String
    let errorType: APIResponseErrorType
    let message: [String]
    let statusCode: Int
}
