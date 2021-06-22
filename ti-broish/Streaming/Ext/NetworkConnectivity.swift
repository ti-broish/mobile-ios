//
//  NetworkConnectivity.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 29.03.21.
//

import SystemConfiguration
import CoreTelephony
import Foundation

enum ConnectivityType {
    case noInternet
    case unknown
    case cellular2g
    case cellular3g
    case cellular4g
    case wifi
}

func checkConnectivity(toUrl: String) -> ConnectivityType {
    guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, toUrl) else {
        return .noInternet
    }
    
    var flags = SCNetworkReachabilityFlags()
    SCNetworkReachabilityGetFlags(reachability, &flags)
    
    let isReachable = flags.contains(.reachable)
    let isWWAN = flags.contains(.isWWAN)
    
    if (isReachable) {
        if (isWWAN) {
            let networkInfo = CTTelephonyNetworkInfo()
            let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
            
            guard let carrierTypeName = carrierType?.first?.value else {
                return .unknown
            }
            
            switch carrierTypeName {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return .cellular2g
                case CTRadioAccessTechnologyLTE:
                    return .cellular4g
                default:
                    return .cellular3g
            }
        } else {
            return .wifi
        }
    } else {
        return .noInternet
    }
}
