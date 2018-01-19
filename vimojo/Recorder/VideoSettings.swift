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
    static var format: VideoCodec = .H264 {
        didSet {
            // TODO: Write to defaults
        }
    }
    static var resolution: Resolution = .sevenHundred {
        didSet {
            // TODO: Write to defaults
        }
    }
    static var fps: FrameRate = .thirty {
        didSet {
            // TODO: Write to defaults
        }
    }
    static var bitRate: BitRate = .sixteenMB {
        didSet {
            // TODO: Write to defaults
        }
    }
    
    private static var compressionProperties: [String: Any] = [
        AVVideoAverageBitRateKey : bitRate.value,
        AVVideoExpectedSourceFrameRateKey : fps.rawValue,
    ]
    public static var videoSettings: [String: Any] {
        return [
            AVVideoCodecKey: format.value,
            AVVideoWidthKey: resolution.width,
            AVVideoHeightKey: resolution.height,
            AVVideoCompressionPropertiesKey: compressionProperties
        ]
    }
    
    init() {
        // TODO: on creation load data from defaults
    }
}

enum Resolution {
    case sevenHundred
    case oneThousand
    case fourThousand
    
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
enum BitRate: NSNumber {
    
    case sixteenMB
    case thirtyTwoMB
    
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
    
    var value: String {
        switch self {
        case .H264: return AVVideoCodecH264
        }
    }
}
enum FrameRate: NSNumber {
    case thirty = 30
    case twentyFour = 24
    case sixty = 60
}