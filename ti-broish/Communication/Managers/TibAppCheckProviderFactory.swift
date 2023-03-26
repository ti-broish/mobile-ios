//
//  TibAppCheckProviderFactory.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 24.03.23.
//

import Firebase

final class TibAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
