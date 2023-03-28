//
//  SendProtocolResponse.swift
//  ti-broish
//
//  Created by Viktor Georgiev on 28.04.21.
//

import Foundation

struct SendProtocolResponse: Decodable {
    
    // MARK: Properties
    
    let id: String
    let section: Section?
    let pictures: [Picture]
    let status: ProtocolStatus
    
}
