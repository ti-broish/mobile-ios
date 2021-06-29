//
//  StartStreamViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 28.06.21.
//

import UIKit
import Combine

final class StartStreamViewModel: BaseViewModel, CoordinatableViewModel {
    
    let startStreamPublisher = PassthroughSubject<StreamResponse, Never>()
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForSendField(type: fieldType)
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
    
    func tryStartStream(section: Section) {
        loadingPublisher.send(true)
        APIManager.shared.startStream(section: section) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let stream):
                print("start stream: \(stream)")
                strongSelf.startStreamPublisher.send(stream)
            case .failure(let error):
                strongSelf.sendPublisher.send(error)
            }
        }
    }
}
