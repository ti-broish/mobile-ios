//
//  ProtocolsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.06.21.
//

import Foundation

final class ProtocolsViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var protocols = [Protocol]()
    
    func start() {
        if LocalStorage.User().isLoggedIn {
            getProtocols()
        } else {
            getLocalProtocols()
        }
    }
    
    func getLocalProtocols() {
        let localProtocols = LocalStorage.Protocols().getProtocols()
        
        if !localProtocols.isEmpty {
            for localProtocol in localProtocols {
                let newProtocol = Protocol(
                    id: localProtocol.id,
                    pictures: localProtocol.pictures,
                    section: localProtocol.section,
                    status: localProtocol.status,
                    statusLocalized: localProtocol.status.localizedStatus,
                    statusColor: localProtocol.status.colorString
                )
                
                if protocols.first(where: { $0.id == newProtocol.id }) == nil {
                    protocols.append(newProtocol)
                }
            }
            
            reloadDataPublisher.send(nil)
        }
    }
    
    // MARK: - Private methods
    
    private func getProtocols() {
        loadingPublisher.send(true)
        APIManager.shared.getProtocols { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let protocols):
                strongSelf.protocols = protocols
                strongSelf.reloadDataPublisher.send(nil)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
            }
        }
    }
}
