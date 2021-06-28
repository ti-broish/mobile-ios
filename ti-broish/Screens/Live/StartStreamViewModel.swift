//
//  StartStreamViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import UIKit

final class StartStreamViewModel: BaseViewModel, CoordinatableViewModel {
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForField(type: fieldType)
        else {
            return
        }
        
        resetFieldsData(for: fieldType)
        setFieldValue(value, forFieldAt: index)
        toggleCityRegionField()
        prefillFieldValue(for: fieldType, value: value)
    }
    
    override func loadDataFields() {
        if isAbroad {
            resetAndReload(fields: SendFieldType.streamingAbroadFields)
        } else {
            resetAndReload(fields: SendFieldType.streamingFields)
        }
    }
    
    func start() {
        loadDataFields()
    }
}
