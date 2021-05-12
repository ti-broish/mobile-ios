//
//  RequestInterceptor.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.05.21.
//

import Alamofire
import Firebase

final class RequestInterceptor: Alamofire.RequestInterceptor {

    private let storage: LocalStorage.User
    private let host: String

    init(storage: LocalStorage, host: String) {
        self.storage = LocalStorage.User()
        self.host = host
    }

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard urlRequest.url?.absoluteString.hasPrefix(host) == true, urlRequest.url?.path != "/organizations" else {
            /// If the request does not require authentication, we can directly return it as unmodified.
            return completion(.success(urlRequest))
        }
        
        var urlRequest = urlRequest
        /// Set the Authorization header value using the access token.
        let accessToken = storage.getJwt() ?? ""
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        completion(.success(urlRequest))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            /// The request did not fail due to a 401 Unauthorized response.
            /// Return the original error and don't retry the request.
            return completion(.doNotRetryWithError(error))
        }
        // Refresh token
        Auth.auth().currentUser?.getIDToken { [weak self] authToken, authError in
            if let newToken = authToken {
                let currentToken = self?.storage.getJwt() ?? ""
                
                if newToken != currentToken {
                    LocalStorage.User().setJwt(newToken)
                    completion(.retry)
                } else {
                    completion(.doNotRetryWithError(error))
                }
            } else if let _authError = authError {
                LocalStorage.User().reset()
                // TODO: - logout
                completion(.doNotRetryWithError(_authError))
            } else {
                completion(.doNotRetryWithError(error))
            }
        }
    }
}
