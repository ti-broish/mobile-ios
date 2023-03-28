//
//  RequestInterceptor.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 10.05.21.
//

import Alamofire
import Firebase

final class RequestInterceptor: Alamofire.RequestInterceptor {
    private let userStorage: LocalStorage.User
    private let appCheckStorage: LocalStorage.AppCheck
    private let host: String

    init(userStorage: LocalStorage.User, appCheckStorage: LocalStorage.AppCheck, host: String) {
        self.userStorage = userStorage
        self.appCheckStorage = appCheckStorage
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
        if let accessToken = userStorage.getJwt() {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        } else if let appCheckToken = appCheckStorage.getToken() {
            // Note: - Enable Firebase AppCheck (in AppDelegate)
            urlRequest.setValue(appCheckToken, forHTTPHeaderField: "X-Firebase-AppCheck")
            urlRequest.setValue("Bearer " + appCheckToken, forHTTPHeaderField: "Authorization")
        }
        // TODO: - handle invalid authorization token if needed
        if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            urlRequest.setValue("Ti Broish iOS v\(appVersion)", forHTTPHeaderField: "User-Agent")
            completion(.success(urlRequest))
        } else {
            completion(.failure(APIError.userAgentHeaderNotSet))
        }
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
        if userStorage.isLoggedIn {
            Auth.auth().currentUser?.getIDToken { [weak self] authToken, authError in
                if let newToken = authToken {
                    let currentToken = self?.userStorage.getJwt() ?? ""
                    
                    if newToken != currentToken {
                        LocalStorage.User().setJwt(newToken)
                        completion(.retry)
                    } else {
                        completion(.doNotRetryWithError(error))
                    }
                } else if let authError = authError {
                    LocalStorage.User().reset()
                    // TODO: - logout
                    completion(.doNotRetryWithError(authError))
                } else {
                    completion(.doNotRetryWithError(error))
                }
            }
        } else {
            APIManager.shared.getAppCheckToken(forcingRefresh: true) { [weak self] response in
                switch response {
                case .success(let newToken):
                    let currentToken = self?.appCheckStorage.getToken() ?? ""
                    if newToken != currentToken {
                        self?.appCheckStorage.setToken(newToken)
                        completion(.retry)
                    } else {
                        completion(.doNotRetryWithError(error))
                    }
                case .failure(let error):
                    completion(.doNotRetryWithError(error))
                }
            }
        }
    }
}
