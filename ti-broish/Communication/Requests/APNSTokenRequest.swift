//
//  APNSTokenRequest.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 27.04.21.
//

import Foundation
import FirebaseMessaging

struct APNSTokenRequest: RequestProvider {
    
    var path: String {
        "/me/clients"
    }
    
    var parameters: [String : Any?] {
        [
            "token": Messaging.messaging().fcmToken
        ]
    }
}
