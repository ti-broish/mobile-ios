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
    private (set) var searchType: SearchType?
    private var electionRegions = [ElectionRegion]()
    private var municipalities = [Municipality]()
    
    var numberOfRows: Int {
        return lastSearchedText.isEmpty ? searchData.count : filteredSearchData.count
    }
    
    var items: [SearchItem] {
        return lastSearchedText.isEmpty ? searchData : filteredSearchData
    }
    
    // MARK: - Public Methods
    
    override func loadDataFields() {
        
    }
    
    func setSearchType(_ searchType: SearchType?, isAbroad: Bool = false) {
        self.searchType = searchType
        self.isAbroad = isAbroad
    }
    
    func start() {
        guard let searchType = searchType else {
            assertionFailure("searchType is not set")
            return
        }
        
        loadingPublisher.send(true)
        
        switch searchType {
        case .countries:
            getCountries(isAbroad: isAbroad)
        case .electionRegions:
            getElectionRegions(isAbroad: isAbroad)
        case .municipalities:
            loadingPublisher.send(false)
        case .cityRegions:
            loadingPublisher.send(false)
        case .organizations:
            getOrganizations()
        default:
            break
        }
    }
    
    func filter(by text: String) {
        lastSearchedText = text
        
        filteredSearchData.removeAll()
        filteredSearchData = searchData.filter { $0.name.lowercased().contains(lastSearchedText.lowercased()) }
    }
       
    func loadMunicipalities(_ municipalities: [Municipality]) {
        searchData = SearchResultsMapper.mapMunicipalities(municipalities)
        reloadDataPublisher.send(nil)
    }
    
    func getTowns(country: Country, electionRegion: ElectionRegion?, municipality: Municipality?) {
        APIManager.shared.getTowns(
            country: country,
            electionRegion: electionRegion,
            municipality: municipality
        ) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let towns):
                strongSelf.searchData = SearchResultsMapper.mapTowns(towns)
                
                strongSelf.reloadDataPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
                strongSelf.loadingPublisher.send(false)
            }
        }
    }
    
    func loadCityRegions(_ cityRegions: [CityRegion]) {
        searchData = SearchResultsMapper.mapCityRegions(cityRegions)
        reloadDataPublisher.send(nil)
    }
    
    func getSections(town: Town, cityRegion: CityRegion?) {
        APIManager.shared.getSections(town: town, cityRegion: cityRegion) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let sections):
                strongSelf.searchData = SearchResultsMapper.mapSections(sections)
                
                strongSelf.reloadDataPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
                strongSelf.loadingPublisher.send(false)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func getCountries(isAbroad: Bool) {
        APIManager.shared.getCountries(isAbroad: isAbroad) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let countries):
                strongSelf.searchData = SearchResultsMapper.mapCountries(countries)
                strongSelf.reloadDataPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
                strongSelf.loadingPublisher.send(false)
            }
        }
    }
    
    private func getElectionRegions(isAbroad: Bool) {
        APIManager.shared.getElectionRegions(isAbroad: isAbroad) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let electionRegions):
                strongSelf.searchData = SearchResultsMapper.mapElectionRegions(electionRegions)
                strongSelf.reloadDataPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
                strongSelf.loadingPublisher.send(false)
            }
        }
    }
    
    private func getOrganizations() {
        APIManager.shared.getOrganizations() { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            switch response {
            case .success(let organizations):
                strongSelf.searchData = SearchResultsMapper.mapOrganizations(organizations)
                strongSelf.reloadDataPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.reloadDataPublisher.send(error)
                strongSelf.loadingPublisher.send(false)
            }
        }
    }
}
