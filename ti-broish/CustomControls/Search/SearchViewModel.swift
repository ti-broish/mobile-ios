//
//  SearchViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Combine

final class SearchViewModel: BaseViewModel, CoordinatableViewModel {
    
    private var lastSearchedText = ""
    private var searchData = [SearchItem]()
    private var filteredSearchData = [SearchItem]()
    
    var numberOfRows: Int {
        return lastSearchedText.isEmpty ? searchData.count : filteredSearchData.count
    }
    
    var items: [SearchItem] {
        return lastSearchedText.isEmpty ? searchData : filteredSearchData
    }
    
    // MARK: - Public Methods
    
    func start() {
        
    }
    
    func filter(by text: String) {
        lastSearchedText = text
        
        filteredSearchData.removeAll()
        filteredSearchData = searchData.filter { $0.name.lowercased().contains(lastSearchedText.lowercased()) }
    }
    
    func getOrganizations() {
        data.removeAll()
        
        APIManager.shared.getOrganizations() { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let organizations):
                strongSelf.searchData = SearchResultsMapper.mapOrganizations(organizations)
                strongSelf.reloadDataPublisher.send()
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
}
