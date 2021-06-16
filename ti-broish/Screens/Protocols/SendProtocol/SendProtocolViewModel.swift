//
//  SendProtocolViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import Foundation

enum SendProtocolSection: Int, CaseIterable {
    
    case data
    case pictures
}

final class SendProtocolViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var pictures = [Picture]()
    
    override func loadDataFields() {
        let builder = SendProtocolDataBuilder()
        
        SendProtocolFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = SendProtocolFieldType(rawValue: indexPath.row) else {
            return
        }
        
        setFieldValue(value, forFieldAt: field.rawValue)
    }
    
    func start() {
        loadDataFields()
    }
    
    // MARK: - Private methods    
}

