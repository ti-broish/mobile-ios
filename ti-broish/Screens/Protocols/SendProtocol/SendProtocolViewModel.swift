//
//  SendProtocolViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import UIKit

final class SendProtocolViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var images = [UIImage]()
    
    override func loadDataFields() {
        let builder = SendProtocolDataBuilder()
        
        SendFieldType.protocolFields.forEach {
            if let config = builder.makeConfig(for: $0) {
                data.append(config)
            }
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForField(type: fieldType)
        else {
            return
        }
        
        setFieldValue(value, forFieldAt: index)
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

