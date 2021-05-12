//
//  SearchViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Combine

final class SearchViewModel: CoordinatableViewModel {
    
    private (set) var data = [SearchItem]()
    
    let reloadDataPublisher = PassthroughSubject<Void, APIError>()
    
    // MARK: - Public Methods
    
    func start() {
        
    }
    
    func getOrganizations() {
        data.removeAll()
        
        APIManager.shared.getOrganizations() { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let organizations):
                strongSelf.data = SearchResultsMapper.mapOrganizations(organizations)
                strongSelf.reloadDataPublisher.send()
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
}
