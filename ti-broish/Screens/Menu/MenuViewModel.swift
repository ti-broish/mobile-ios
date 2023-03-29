//
//  MenuViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 4/13/21.
//  
//

final class MenuViewModel: CoordinatableViewModel {
    
    private (set) var menuItems = [MenuItem]()
    
    init() {
        start()
    }
    
    // MARK: - Public Methods
    
    func start() {
        setupMenuItems(isLoggedIn: LocalStorage.User().isLoggedIn)
    }
    
    // MARK: - Private methods
    
    private func setupMenuItems(isLoggedIn: Bool) {
        menuItems.removeAll()
        
        menuItems.append(MenuItem(type: .sendProtocol))
        menuItems.append(MenuItem(type: .sendViolation))
//        menuItems.append(MenuItem(type: .live))
        
        if isLoggedIn {
            menuItems.append(MenuItem(type: .checkin))
            menuItems.append(MenuItem(type: .protocols))
            menuItems.append(MenuItem(type: .violations))
        }

        menuItems.append(MenuItem(type: .terms))
        
        if isLoggedIn {
            menuItems.append(MenuItem(type: .profile))
            menuItems.append(MenuItem(type: .logout))
        } else {
            menuItems.append(MenuItem(type: .login))
        }
    }
}
