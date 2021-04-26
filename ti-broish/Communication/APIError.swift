//
//  APIError.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 26.04.21.
//

import Foundation

public enum APIError: Error {
    /// Failed to create a valid `URL` from `APIRequest`'s baseUrl.
    case invalidBaseUrl

    /// Api Request failed with an underlying error.
    case requestFailed(error: Error)

    // MARK: - Encoding

    /// JSON serialization failed with an underlying system error during the encoding process.
    case jsonEncodingFailed(error: Error)
    /// Parameter serialization failed with an underlying system error during the encoding process.
    case parameterEncodingFailed(error: Error)
    /// The `URLRequest` did not have a `URL` to encode.
    case missingURL

    // MARK: - Authorization

    /// Authorization token is empty
    case invalidAuthorizationToken
}
