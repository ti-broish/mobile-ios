//
//  MenuItem.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

enum MenuItemType {
    
    case profile, sendProtocol, sendViolation, protocols, violations, terms, live, logout
}

struct MenuItem {
    
    let type: MenuItemType
    
    var title: String {
        switch type {
        case .profile:
            return LocalizedStrings.Menu.profile
        case .sendProtocol:
            return LocalizedStrings.Menu.sendProtocol
        case .sendViolation:
            return LocalizedStrings.Menu.sendViolation
        case .protocols:
            return LocalizedStrings.Menu.protocols
        case .violations:
            return LocalizedStrings.Menu.violations
        case .terms:
            return LocalizedStrings.Menu.terms
        case .live:
            return LocalizedStrings.Menu.live
        case .logout:
            return LocalizedStrings.Menu.logout
        }
    }
}
