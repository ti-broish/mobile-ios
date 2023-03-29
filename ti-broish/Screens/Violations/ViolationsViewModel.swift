//
//  ViolationsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class ViolationsViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var violations = [Violation]()
    
    func start() {
        if LocalStorage.User().isLoggedIn {
            getViolations()
        } else {
            getLocalViolations()
        }
    }
    
    func getLocalViolations() {
        let localViolations = LocalStorage.Violations().getViolations()
        
        if !localViolations.isEmpty {
            for localViolation in localViolations {
                let newViolation = Violation(
                    id: localViolation.id,
                    description: localViolation.description,
                    pictures: localViolation.pictures,
                    section: localViolation.section,
                    status: localViolation.status,
                    statusLocalized: localViolation.status.localizedStatus,
                    statusColor: localViolation.status.colorString
                )
                
                if violations.first(where: { $0.id == newViolation.id }) == nil {
                    violations.append(newViolation)
                }
            }
            
            reloadDataPublisher.send(nil)
        }
    }
    
    // MARK: - Private methods
    
    private func getViolations() {
        loadingPublisher.send(true)
        APIManager.shared.getViolations { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let violations):
                strongSelf.violations = violations
                strongSelf.reloadDataPublisher.send(nil)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
            }
        }
    }
}
