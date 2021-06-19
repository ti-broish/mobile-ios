//
//  SendProtocolViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import UIKit

enum SendProtocolSection: Int, CaseIterable {
    
    case data
    case images
    case buttons
}

final class SendProtocolViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var images = [UIImage]()
    
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
    
    func setImages(_ images: [UIImage]) {
        images.forEach { image in
            if self.images.first(where: { $0 == image }) == nil {
                self.images.append(image)
            }
        }
    }
    
    func removeImage(at index: Int) {
        images.remove(at: index)
    }
    
    func start() {
        loadDataFields()
    }
    
    // MARK: - Private methods    
}

