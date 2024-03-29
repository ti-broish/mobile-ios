//
//  SendProtocolViewModel.swift
//  ti-broish
//
//  Created by Krasimir Slavkov on 15.06.21.
//

import UIKit
import Combine

final class SendProtocolViewModel: SendViewModel, CoordinatableViewModel {
    
    override func loadDataFields() {
        let builder = SendProtocolDataBuilder()
        
        SendFieldType.protocolFields.forEach {
            if let config = builder.makeConfig(for: $0) {
                data.append(config)
            }
        }
        
        loadCheckinDataSectionNumber()
    }
    
    override func updateFieldValue(_ value: AnyObject?, at indexPath: IndexPath) {
        guard
            let fieldType = data[indexPath.row].dataType as? SendFieldType,
            let index = indexForSendField(type: fieldType)
        else {
            return
        }
        
        setFieldValue(value, forFieldAt: index)
    }
    
    func start() {
        loadDataFields()
    }
    
    func uploadImages(section: Section) {
        uploadImages { [weak self] result in
            switch result {
            case .success:
                self?.sendProtocol(section: section)
            case .failure(let error):
                self?.sendPublisher.send(error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func resetData() {
        if let index = indexForSendField(type: .section) {
            setFieldValue(nil, forFieldAt: index)
        }
        
        uploadPhotos.removeAll()
        images.removeAll()
    }
    
    private func sendProtocol(section: Section) {
        let pictures = uploadPhotos.map { $0.id }

        APIManager.shared.sendProtocol(section: section, pictures: pictures) { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case .success(let response):
                LocalStorage.Protocols().storeProtocol(response)
                strongSelf.resetData()
                strongSelf.sendPublisher.send(nil)
                strongSelf.loadingPublisher.send(false)
            case .failure(let error):
                strongSelf.sendPublisher.send(error)
            }
        }
    }

    private func loadCheckinDataSectionNumber() {
        let checkinData = checkinUtils.getStoredCheckinData()
        let field: SendFieldType = .section
        
        if let item = checkinData[field] as? SearchItem,
           let section = item.data as? Section
        {
            updateFieldValue(section as AnyObject, at: IndexPath(row: 0, section: SendSectionType.data.rawValue))
        }
    }
}

