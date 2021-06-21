//
//  SendViolationViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 21.06.21.
//

import UIKit

final class SendViolationViewModel: BaseViewModel, CoordinatableViewModel {
    
    private (set) var images = [UIImage]()
    
    override func loadDataFields() {
        let builder = SendViolationDataBuilder()
        
        SendViolationFieldType.allCases.forEach {
            data.append(builder.makeConfig(for: $0))
        }
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard let field = SendViolationFieldType(rawValue: indexPath.row) else {
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
