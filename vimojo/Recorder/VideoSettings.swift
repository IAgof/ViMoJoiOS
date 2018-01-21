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
			defaults.set(codec.value, forKey: codec.defaultsKey)
        }
    }
    static var resolution: Resolution = .sevenHundred {
        didSet {
            defaults.set(resolution.height, forKey: resolution.defaultsKey)
        }
    }
    static var fps: FrameRate = .thirty {
        didSet {
            defaults.set(fps.rawValue, forKey: fps.defaultsKey)
        }
    }
    static var bitRate: BitRate = .sixteenMB {
        didSet {
            defaults.set(bitRate.value, forKey: bitRate.defaultsKey)
        }
    }
    
    private static var compressionProperties: [String: Any] = [
        AVVideoAverageBitRateKey : bitRate.value,
        AVVideoExpectedSourceFrameRateKey : fps.rawValue,
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
        codec = (defaults.object(forKey: codec.defaultsKey) as? VideoCodec) ?? .H264
        resolution = (defaults.object(forKey: resolution.defaultsKey) as? Resolution) ?? .sevenHundred
        bitRate = (defaults.object(forKey: bitRate.defaultsKey) as? BitRate) ?? .sixteenMB
        fps = (defaults.object(forKey: fps.defaultsKey) as? FrameRate) ?? .thirty
    }
}

enum Resolution {
    case sevenHundred
    case oneThousand
    case fourThousand
    
    var defaultsKey: String {
        return "VideoSettingsResolution"
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
}
enum BitRate {
    
    case sixteenMB
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
enum VideoCodec {
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
enum FrameRate: NSNumber {
    case thirty = 30
    case twentyFive = 25
    case sixty = 60
   
    var defaultsKey: String {
        return "VideoSettingsFrameRate"
    }
}
