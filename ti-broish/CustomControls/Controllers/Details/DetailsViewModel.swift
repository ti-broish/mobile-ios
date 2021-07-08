//
//  DetailsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class DetailsViewModel: BaseViewModel, CoordinatableViewModel {
    
    var protocolId: String? // remote notification
    var protocolItem: Protocol?
    
    var violationId: String? // remote notification
    var violation: Violation?
    
    var pictures: [Picture] {
        return protocolItem?.pictures ?? violation?.pictures ?? []
    }
    
    func start() {
        if let protocolId = protocolId {
            getProtocol(id: protocolId)
        }
        
        if let violationId = violationId {
            getViolation(id: violationId)
        }
    }
    
    // MARK: - Private methods
    
    private func getProtocol(id: String) {
        loadingPublisher.send(true)
        
        APIManager.shared.getProtocol(id: id) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let protocolItem):
                strongSelf.protocolItem = protocolItem
                strongSelf.reloadDataPublisher.send(nil)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
            }
        }
    }
    
    private func getViolation(id: String) {
        loadingPublisher.send(true)
        
        APIManager.shared.getViolation(id: id) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let violation):
                strongSelf.violation = violation
                strongSelf.reloadDataPublisher.send(nil)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
            }
        }
    }
}
