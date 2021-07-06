//
//  CheckinUtils.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 6.07.21.
//

import Foundation

struct CheckinUtils {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    
    var isAbroad: Bool {
        return (storedData(forKey: storeKey(for: .countries), type: Country.self) as? Country) != nil
    }
        
    func storeCheckin(data: [SendFieldType: AnyObject?]) {
        reset()
        
        if let country = data[.countries] as? Country {
            store(data: country, key: storeKey(for: .countries))
        }
        
        if let electionRegion = data[.electionRegion] as? ElectionRegion {
            store(data: electionRegion, key: storeKey(for: .electionRegion))
        }
        
        if let municipality = data[.municipality] as? Municipality {
            store(data: municipality, key: storeKey(for: .municipality))
        }

        if let town = data[.town] as? Town {
            store(data: town, key: storeKey(for: .town))
        }
        
        if let cityRegion = data[.cityRegion] as? CityRegion {
           store(data: cityRegion, key: storeKey(for: .cityRegion))
        }
        
        if let section = data[.section] as? Section {
            store(data: section, key: storeKey(for: .section))
        }
    }
    
    func getStoredCheckinData() -> [SendFieldType: AnyObject?] {
        var data = [SendFieldType: AnyObject?]()
        
        if let country = storedData(forKey: storeKey(for: .countries), type: Country.self) as? Country {
            data[.countries] = SearchItem(
                id: -1,
                name: country.name,
                code: country.code,
                type: .country,
                parentCellIndexPath: nil,
                data: country as AnyObject
            ) as AnyObject
        }
        
        if let electionRegion = storedData(forKey: storeKey(for: .electionRegion), type: ElectionRegion.self) as? ElectionRegion {
            data[.electionRegion] = SearchItem(
                id: -1,
                name: electionRegion.name,
                code: electionRegion.code,
                type: .electionRegion,
                parentCellIndexPath: nil,
                data: electionRegion as AnyObject
            ) as AnyObject
        }
        
        if let municipality = storedData(forKey: storeKey(for: .municipality), type: Municipality.self) as? Municipality {
            data[.municipality] = SearchItem(
                id: -1,
                name: municipality.name,
                code: municipality.code,
                type: .municipality,
                parentCellIndexPath: nil,
                data: municipality as AnyObject
            ) as AnyObject
        }
        
        if let town = storedData(forKey: storeKey(for: .town), type: Town.self) as? Town {
            data[.town] = SearchItem(
                id: town.id,
                name: town.name,
                code: "",
                type: .town,
                parentCellIndexPath: nil,
                data: town as AnyObject
            ) as AnyObject
        }
        
        if let cityRegion = storedData(forKey: storeKey(for: .cityRegion), type: CityRegion.self) as? CityRegion {
            data[.cityRegion] = SearchItem(
                id: -1,
                name: cityRegion.name,
                code: cityRegion.code,
                type: .cityRegion,
                parentCellIndexPath: nil,
                data: cityRegion as AnyObject
            ) as AnyObject
        }
        
        if let section = storedData(forKey: storeKey(for: .section), type: Section.self) as? Section {
            data[.section] = SearchItem(
                id: Int(section.id) ?? -1,
                name: section.name ?? section.place,
                code: section.code,
                type: .section,
                parentCellIndexPath: nil,
                data: section as AnyObject
            ) as AnyObject
        }
        
        return data
    }
    
    // MARK: - Private methods
    
    private func store<T: Encodable>(data: T, key: String) {
        if let jsonData = try? encoder.encode(data) {
            userDefaults.set(jsonData, forKey: key)
        }
    }
    
    private func storedData<T: Decodable>(forKey key: String, type: T.Type) -> AnyObject? {
        guard
            let jsonData = userDefaults.data(forKey: key),
            let data = try? decoder.decode(T.self, from: jsonData)
        else {
            return nil
        }
        
        return data as AnyObject
    }
    
    private func storeKey(for sendFieldType: SendFieldType) -> String {
        switch sendFieldType {
        case .countryCheckbox:
            return "checkinCountryCheckbox"
        case .countries:
            return "checkinCountries"
        case .electionRegion:
            return "checkinElectionRegion"
        case .municipality:
            return "checkinMunicipality"
        case .town:
            return "checkinTown"
        case .cityRegion:
            return "checkinCityRegion"
        case .section:
            return "checkinSection"
        case .sectionNumber:
            return "checkinSectionNumber"
        case .description:
            return "checkinDescription"
        case .organization:
            return "checkinOrganization"
        }
    }
    
    private func reset() {
        userDefaults.removeObject(forKey: storeKey(for: .countries))
        userDefaults.removeObject(forKey: storeKey(for: .electionRegion))
        userDefaults.removeObject(forKey: storeKey(for: .municipality))
        userDefaults.removeObject(forKey: storeKey(for: .town))
        userDefaults.removeObject(forKey: storeKey(for: .cityRegion))
        userDefaults.removeObject(forKey: storeKey(for: .section))
    }
}
