//
//  SearchViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 12.05.21.
//

import Combine

enum SearchType {
    
    case countries
    case electionRegions
    case municipalities
    case towns
    case cityRegions
    case sections
    case organizations
}

final class SearchViewModel: BaseViewModel, CoordinatableViewModel {
    
    private var lastSearchedText = ""
    private var searchData = [SearchItem]()
    private var filteredSearchData = [SearchItem]()
    private var searchType: SearchType?
    private var isAbroad: Bool = false
    
    var numberOfRows: Int {
        return lastSearchedText.isEmpty ? searchData.count : filteredSearchData.count
    }
    
    var items: [SearchItem] {
        return lastSearchedText.isEmpty ? searchData : filteredSearchData
    }
    
    // MARK: - Public Methods
    
    func setSearchType(_ searchType: SearchType?, isAbroad: Bool) {
        self.searchType = searchType
        self.isAbroad = isAbroad
    }
    
    func start() {
        guard let searchType = searchType else {
            assertionFailure("searchType is not set")
            return
        }
        
        switch searchType {
        case .countries:
            getCountries(isAbroad: isAbroad)
        case .electionRegions:
            getElectionRegions(isAbroad: isAbroad)
        case .municipalities:
            getMunicipalities()
        case .towns:
            getTowns()
        case .cityRegions:
            getCityRegions()
        case .sections:
            getSections()
        case .organizations:
            getOrganizations()
        }
    }
    
    func filter(by text: String) {
        lastSearchedText = text
        
        filteredSearchData.removeAll()
        filteredSearchData = searchData.filter { $0.name.lowercased().contains(lastSearchedText.lowercased()) }
    }
    
    // MARK: - Private methods
    private func getCountries(isAbroad: Bool) {
        data.removeAll()
    }
        
    private func getElectionRegions(isAbroad: Bool) {
        data.removeAll()
        
        APIManager.shared.getElectionRegions(isAbroad: isAbroad) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let electionRegions):
                strongSelf.searchData = SearchResultsMapper.mapElectionRegions(electionRegions)
                strongSelf.reloadDataPublisher.send()
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(completion: .failure(error))
            }
        }
    }
        
    private func getMunicipalities() {
        data.removeAll()
    }
        
    private func getTowns() {
        data.removeAll()
    }
    
    private func getCityRegions() {
        data.removeAll()
    }
    
    private func getSections() {
        data.removeAll()
    }
    
    private func getOrganizations() {
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
