//
//  DetailsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class DetailsViewModel: CoordinatableViewModel {
    
    var imagesCount: Int = 0
    
    var protocolItem: Protocol? {
        didSet {
            imagesCount = protocolItem?.pictures.count ?? 0
        }
    }
    
    var violation: Violation? {
        didSet {
            imagesCount = violation?.pictures.count ?? 0
        }
    }
}
