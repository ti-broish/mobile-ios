//
//  SearchViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Combine

final class SearchViewModel: BaseViewModel, CoordinatableViewModel {
    
    private var lastSearchedText = ""
    private var data = [SearchItem]()
    private var filteredData = [SearchItem]()
    
    var numberOfRows: Int {
        return lastSearchedText.isEmpty ? data.count : filteredData.count
    }
    
    var items: [SearchItem] {
        return lastSearchedText.isEmpty ? data : filteredData
    }
    
    // MARK: - Public Methods
    
    func start() {
        
    }
    
    func filter(by text: String) {
        lastSearchedText = text
        
        filteredData.removeAll()
        filteredData = data.filter { $0.name.lowercased().contains(lastSearchedText.lowercased()) }
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
