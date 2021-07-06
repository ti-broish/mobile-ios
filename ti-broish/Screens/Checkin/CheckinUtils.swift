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
    
    func storeCheckin(data: [SendFieldType: AnyObject?]) {
        guard
            let electionRegion = data[.electionRegion] as? ElectionRegion,
            let municipality = data[.municipality] as? Municipality,
            let town = data[.town] as? Town,
            let section = data[.section] as? Section
        else {
            return
        }
        
        store(data: electionRegion, key: storeKey(for: .electionRegion))
        store(data: municipality, key: storeKey(for: .municipality))
        store(data: town, key: storeKey(for: .town))
        store(data: section, key: storeKey(for: .section))

        if let cityRegion = data[.cityRegion] as? CityRegion {
           store(data: cityRegion, key: storeKey(for: .cityRegion))
        }
    }
    
    // MARK: - Private methods
    
    private func store<T: Codable>(data: T, key: String) {
        if let jsonData = try? encoder.encode(data) {
            userDefaults.set(jsonData, forKey: key)
        }
    }
    
//    private func getStoredData<T: Codable>(forKey: String, type: T) -> AnyObject? {
//        if let jsonData = userDefaults.data(forKey: key), decoder.decode(T, from: jsonData)
////        if let jsonData = try? encoder.encode(data) {
////            userDefaults.set(jsonData, forKey: key)
////        }
//    }
    
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
}
