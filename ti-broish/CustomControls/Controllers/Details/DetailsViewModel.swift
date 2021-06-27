//
//  DetailsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class DetailsViewModel: CoordinatableViewModel {
    
    var protocolItem: Protocol?
    var violation: Violation?
    
    var pictures: [Picture] {
        return protocolItem?.pictures ?? violation?.pictures ?? []
    }
}
