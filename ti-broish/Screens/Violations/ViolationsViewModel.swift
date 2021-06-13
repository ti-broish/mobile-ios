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
        getViolations()
    }
    
    // MARK: - Private methods
    
    private func getViolations() {
        APIManager.shared.getViolations { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let violations):
                strongSelf.violations = violations
                strongSelf.reloadDataPublisher.send()
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
}
