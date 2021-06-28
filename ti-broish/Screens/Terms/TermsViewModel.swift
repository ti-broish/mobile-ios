//
//  TermsViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 13.06.21.
//

import Foundation

final class TermsViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var htmlString: String?
    
    func start() {
        loadTerms()
    }
    
    // MARK: - Private methods
    
    private func loadTerms() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.loadingPublisher.send(true)
            
            if let filepath = Bundle.main.path(forResource: "terms", ofType: "html") {
                do {
                    strongSelf.htmlString = try String(contentsOfFile: filepath)
                    strongSelf.reloadDataPublisher.send(nil)
                } catch {
                    strongSelf.reloadDataPublisher.send(error)
                }
            }
        }
    }
}
