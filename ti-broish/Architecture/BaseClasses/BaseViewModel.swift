//
//  BaseViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 11.06.21.
//

import Foundation
import Combine

protocol DataFieldModel {
    
    var data: [InputFieldConfig] { get set }
    
    func loadDataFields()
    func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath)
    
    func setFieldValue(_ value: AnyObject?, forFieldAt index: Int)
    func getFieldValue(forFieldAt index: Int) -> AnyObject?
}

class BaseViewModel: DataFieldModel {
    
    let reloadDataPublisher = PassthroughSubject<Error?, Never>()
    let loadingPublisher = PassthroughSubject<Bool, Never>()
    let sendPublisher = PassthroughSubject<APIError?, Never>()
    var data: [InputFieldConfig] = [InputFieldConfig]()
    
    func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        assertionFailure("updateFieldValuel:at not implemented")
    }
    
    func loadDataFields() {
        assertionFailure("loadDataFields not implemented")
    }
    
    func setFieldValue(_ value: AnyObject?, forFieldAt index: Int) {
        data[index].data = value
    }
    
    func getFieldValue(forFieldAt index: Int) -> AnyObject? {
        return data[index].data
    }
    
    func indexForField(type: SendFieldType) -> Int? {
        return data.firstIndex(where: { config in
            guard let dataType = config.dataType as? SendFieldType else {
                return false
            }
            
            return dataType == type
        })
    }
    
    func dataForField(type: SendFieldType) -> AnyObject? {
        guard
            let index = indexForField(type: type),
            let item = data[index].data as? SearchItem
        else {
            return nil
        }
        
        return item.data
    }
}
