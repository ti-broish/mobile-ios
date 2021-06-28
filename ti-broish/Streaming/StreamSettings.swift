//
//  StreamSettings.swift
//  YouCountLive
//
//  Created by Vassil Angelov on 29.03.21.
//

import HaishinKit
import AVFoundation

enum VideoStreamOrientation {
    case portrait
    case landscape
}

final class VideoStreamQuality {
    
    static let lowQuality = VideoStreamQuality(width: 420, height: 270, bitrate: 512 * 1024, fps: 15, preset: .vga640x480)
    static let mediumQuality = VideoStreamQuality(width: 640 , height: 360, bitrate: 512 * 1024, fps: 25,  preset: .vga640x480)
    static let highQuality = VideoStreamQuality(width: 960, height: 540, bitrate: 1024 * 1024, fps: 30, preset: .iFrame960x540)
    
    let width: Int
    let height: Int
    let bitrate: Int
    let fps: Int
    let captureSessionPreset: AVCaptureSession.Preset
    let captureSettings: HaishinKit.Setting<HaishinKit.AVMixer, HaishinKit.AVMixer.Option>
    
    init(width:Int, height: Int, bitrate: Int, fps: Int, preset: AVCaptureSession.Preset) {
        self.width = width
        self.height = height
        self.bitrate = bitrate
        self.fps = fps
        self.captureSessionPreset = preset
        self.captureSettings = [
            .fps: fps,
            .sessionPreset: captureSessionPreset,
            .continuousAutofocus: true,
            .continuousExposure: true
    ]
    }
}

extension HaishinKit.Setting where T == HaishinKit.H264Encoder, Key == HaishinKit.H264Encoder.Option {
    
    static func settings(for quality: VideoStreamQuality, orientation: VideoStreamOrientation) -> HaishinKit.Setting<HaishinKit.H264Encoder, HaishinKit.H264Encoder.Option> {
        let width: Int
        let height: Int
        switch (orientation) {
            case .portrait:
                width = quality.height
                height = quality.width
            case .landscape:
                width = quality.width
                height = quality.height
        }
        
        return [
            .width: width,
            .height: height,
            .bitrate: quality.bitrate
        ]
    }
}

extension HaishinKit.Setting where T == HaishinKit.AudioCodec, Key == HaishinKit.AudioCodec.Option {
    
    static let `default`: HaishinKit.Setting<HaishinKit.AudioCodec, HaishinKit.AudioCodec.Option> = [
        // legal requirement for this version
        .muted: true,
        .bitrate: 128 * 1024
    ]
}

