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
            items.append(
                SearchItem(
                    id: -1,
                    name: region.name,
                    code: region.code,
                    type: .electionRegion,
                    data: region as AnyObject
                )
            )
        }
        
        return items
    }
    
    static func mapMunicipalities(_ municipalities: [Municipality]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for municipality in municipalities {
            items.append(
                SearchItem(
                    id: -1,
                    name: municipality.name,
                    code: municipality.code,
                    type: .municipality,
                    data: municipality as AnyObject
                )
            )
        }
        
        items.sort(by: { $0.name < $1.name })
        
        return items
    }
    
    static func mapTowns(_ towns: [Town]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for town in towns {
            items.append(SearchItem(id: town.id, name: town.name, code: "", type: .town, data: town as AnyObject))
        }
        
        items.sort(by: { $0.name < $1.name })
        
        return items
    }
    
    static func mapCityRegions(_ cityRegions: [CityRegion]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for region in cityRegions {
            items.append(
                SearchItem(
                    id: -1,
                    name: region.name,
                    code: region.code,
                    type: .cityRegion,
                    data: region as AnyObject
                )
            )
        }
        
        items.sort(by: { $0.name < $1.name })
        
        return items
    }
    
    static func mapSections(_ sections: [Section]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for section in sections {
            items.append(
                SearchItem(
                    id: Int(section.id) ?? -1,
                    name: section.name ?? section.place,
                    code: section.code,
                    type: .section,
                    data: section as AnyObject
                )
            )
        }
        
        items.sort(by: { $0.name < $1.name })
        
        return items
    }
    
    static func mapOrganizations(_ organizations: [Organization]) -> [SearchItem] {
        var items = [SearchItem]()
        
        for organization in organizations {
            items.append(
                SearchItem(
                    id: organization.id,
                    name: organization.name,
                    code: "",
                    type: .organization,
                    data: organization as AnyObject
                )
            )
        }
        
        return items
    }
}
