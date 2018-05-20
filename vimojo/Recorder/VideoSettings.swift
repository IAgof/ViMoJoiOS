//
//  VideoSettings.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/1/18.
//  Copyright © 2018 Videona. All rights reserved.
//


import Foundation
import AVFoundation

public class VideoSettings {
    static var defaults = UserDefaults.standard

    static var codec: VideoCodec = .H264 {
        didSet {
			defaults.set(codec.rawValue, forKey: codec.defaultsKey)
        }
    }
    static var resolution: Resolution {
        get {
            switch CamSettings.cameraPosition {
            case .back:
                return backResolution
            case .front:
                return frontResolution
            }
        }
        set {
            switch CamSettings.cameraPosition {
            case .back:
                backResolution = newValue
            case .front:
                frontResolution = newValue
            }
        }
    }
    static var backResolution: Resolution = .sevenHundred {
        didSet {
            defaults.set(backResolution.rawValue, forKey: Resolution.backDefaultsKey)
        }
    }
    static var frontResolution: Resolution = .sevenHundred {
        didSet {
            defaults.set(frontResolution.rawValue, forKey: Resolution.frontDefaultsKey)
        }
    }
    static var fps: FrameRate = .thirty {
        didSet {
            defaults.set(fps.rawValue, forKey: fps.defaultsKey)
        }
    }
    static var bitRate: BitRate = .sixteenMB {
        didSet {
            defaults.set(bitRate.rawValue, forKey: bitRate.defaultsKey)
        }
    }
    static func updateFps(to device: AVCaptureDevice) {
        do {
            try device.lockForConfiguration()
            device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps.value))
            device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps.value))
            device.unlockForConfiguration()
        } catch {
            return
        }
    }
    private static var compressionProperties: [String: Any] = [
        AVVideoAverageBitRateKey : bitRate.value,
        AVVideoProfileLevelKey: AVVideoProfileLevelH264High40
    ]
    public static var videoSettings: [String: Any] {
        return [
            AVVideoCodecKey: codec.value,
            AVVideoWidthKey: resolution.width,
            AVVideoHeightKey: resolution.height,
            AVVideoCompressionPropertiesKey: compressionProperties
        ]
    }
    
    static func loadValues() {
        codec = VideoCodec(rawValue: defaults.integer(forKey: codec.defaultsKey)) ?? .H264
        backResolution = Resolution(rawValue: defaults.integer(forKey: Resolution.backDefaultsKey)) ?? .sevenHundred
        frontResolution = Resolution(rawValue: defaults.integer(forKey: Resolution.frontDefaultsKey)) ?? .sevenHundred
        bitRate = BitRate(rawValue: defaults.integer(forKey: bitRate.defaultsKey)) ?? .sixteenMB
        fps = FrameRate(rawValue: defaults.integer(forKey: fps.defaultsKey)) ?? .thirty
    }
}

enum Resolution: Int {
    case sevenHundred = 0
    case oneThousand
    case fourThousand
    
    static var backDefaultsKey: String {
        return "VideoSettingsResolutionBack"
    }
    static var frontDefaultsKey: String {
        return "VideoSettingsResolutionFront"
    }
    var width: NSNumber {
        switch self {
        case .sevenHundred: return 1280
        case .oneThousand: return 1920
        case .fourThousand: return 3840
        }
    }
    var height: NSNumber {
        switch self {
        case .sevenHundred: return 720
        case .oneThousand: return 1080
        case .fourThousand: return 2160
        }
    }
    var preset: (AVCaptureDevice) -> String {
        return { device in
            let isFrontCamera = device.position == .front
            switch self {
            case .sevenHundred:
                return AVOutputSettingsPreset1280x720
            case .oneThousand:
                return AVOutputSettingsPreset1920x1080
            case .fourThousand:
                return isFrontCamera ?
                AVOutputSettingsPreset3840x2160 : AVOutputSettingsPreset1920x1080
            }
        }
    }
}
enum BitRate: Int {
    case sixteenMB = 0
    case thirtyTwoMB
    
    var defaultsKey: String {
        return "VideoSettingsBitRate"
    }
    var mega: (Int) -> Int {
        return { value in
            return 1024*1024*value
        }
    }
    var value: Int {
        switch self {
        case .sixteenMB: return mega(16)
        case .thirtyTwoMB: return mega(32)
        }
    }
}
enum VideoCodec: Int {
    case H264

    var defaultsKey: String {
        return "VideoSettingsVideoCodec"
    }
    var value: String {
        switch self {
        case .H264: return AVVideoCodecH264
        }
    }
}
enum FrameRate: Int {
    case twentyFive = 0
    case thirty
	case sixty
   
    var defaultsKey: String {
        return "VideoSettingsFrameRate"
    }
    
    var value: NSNumber {
        switch self {
        case .twentyFive: return 25
        case .thirty: return 30
		case .sixty: return 60
        }
    }
}
