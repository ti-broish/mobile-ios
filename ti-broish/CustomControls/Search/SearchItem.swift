//
//  SearchItem.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Foundation

enum SearchItemType {
    
    case organization, country, electionRegion, town, municipality, cityRegion, phone, section, parties
}

struct SearchItem {
    
    let id: Int
    let name: String
    let code: String
    let type: SearchItemType
    var parentCellIndexPath: IndexPath?
}
