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
    static var resolution: Resolution = .sevenHundred {
        didSet {
            defaults.set(resolution.rawValue, forKey: resolution.defaultsKey)
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
    
    private static var compressionProperties: [String: Any] = [
        AVVideoAverageBitRateKey : bitRate.value,
    ]
    public static var videoSettings: [String: Any]? {
        let outputSettings = AVOutputSettingsAssistant(preset: resolution.preset)
        outputSettings?.sourceVideoAverageFrameDuration = CMTimeMake(1, Int32(fps.value))
        return outputSettings?.videoSettings
    }
    
    static func loadValues() {
        codec = VideoCodec(rawValue: defaults.integer(forKey: codec.defaultsKey)) ?? .H264
        resolution = Resolution(rawValue: defaults.integer(forKey: resolution.defaultsKey)) ?? .sevenHundred
        bitRate = BitRate(rawValue: defaults.integer(forKey: bitRate.defaultsKey)) ?? .sixteenMB
        fps = FrameRate(rawValue: defaults.integer(forKey: fps.defaultsKey)) ?? .thirty
    }
}

enum Resolution: Int {
    case sevenHundred = 0
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
    var preset: String {
        switch self {
        case .sevenHundred: return AVOutputSettingsPreset1280x720
        case .oneThousand: return AVOutputSettingsPreset1920x1080
        case .fourThousand: return AVOutputSettingsPreset3840x2160
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
