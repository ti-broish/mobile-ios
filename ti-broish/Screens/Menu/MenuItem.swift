//
//  MenuItem.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

enum MenuItemType {
    
    case profile, sendProtocol, sendViolation, live, checkin, protocols, violations, terms, logout, login
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
        case .live:
            return LocalizedStrings.Menu.live
        case .checkin:
            return LocalizedStrings.Menu.checkin
        case .protocols:
            return LocalizedStrings.Menu.protocols
        case .violations:
            return LocalizedStrings.Menu.violations
        case .terms:
            return LocalizedStrings.Menu.terms
        case .logout:
            return LocalizedStrings.Menu.logout
        case .login:
            return LocalizedStrings.Menu.login
        }
    }
}
