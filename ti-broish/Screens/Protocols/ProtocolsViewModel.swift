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
        getProtocols()
    }
    
    // MARK: - Private methods
    
    private func getProtocols() {
        APIManager.shared.getProtocols { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let protocols):
                strongSelf.protocols = protocols
                strongSelf.reloadDataPublisher.send()
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
}
