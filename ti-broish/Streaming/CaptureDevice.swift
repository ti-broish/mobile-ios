//
//  CaptureDevice.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 28.03.21.
//

import AVFoundation

enum CaptureDevice {
    case audio
    case video
    
    var mediaType: AVMediaType {
        switch self {
            case .audio:
                return .audio
            case .video:
                return .video
        }
    }
}

extension CaptureDevice {
    
   static func checkPermissions(for allPermissions: Set<CaptureDevice>, required: Set<CaptureDevice>, completion: @escaping (Bool, Set<CaptureDevice>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var permissionsGranted: Set<CaptureDevice> = []
        
        allPermissions.forEach { (permission) in
            dispatchGroup.enter()
            AVCaptureDevice.requestPermissionsIfNeeded(for: permission.mediaType) { (granted) in
                if granted {
                    permissionsGranted.insert(permission)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            if required.subtracting(permissionsGranted).count > 0 {
                completion(false, permissionsGranted)
            } else {
                completion(true, permissionsGranted)
            }
        }
    }
}

extension AVCaptureDevice {
    static func requestPermissionsIfNeeded(for type: AVMediaType, completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: type)
        switch status {
            case .authorized:
                completion(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: type, completionHandler: completion)
            case .restricted:
                fallthrough
            case .denied:
                fallthrough
            @unknown default:
                completion(false)
        }
    }
}
