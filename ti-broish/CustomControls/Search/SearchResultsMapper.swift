//
//  SearchResultsMapper.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Foundation

struct SearchResultsMapper {
    
    static func mapElectionRegions(_ electionRegions: [ElectionRegion]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for region in electionRegions {
            items.append(SearchItem(id: -1, name: region.name, code: region.code, type: .electionRegion))
        }
        
        return items
    }
    
    static func mapOrganizations(_ organizations: [Organization]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for organization in organizations {
            items.append(SearchItem(id: organization.id, name: organization.name, code: "", type: .organization))
        }
        
        return items
    }
}
