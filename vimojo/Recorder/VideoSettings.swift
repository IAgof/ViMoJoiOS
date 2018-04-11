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
    static var activeFormat: (Array<AVCaptureDevice.Format>, FrameRate) -> AVCaptureDevice.Format? {
        return { formats, fps in
            var formats = formats
            formats = formats.filter({ (format) -> Bool in
                let timeRanges = format.videoSupportedFrameRateRanges as!  [AVFrameRateRange]
                let containsTimeRange = timeRanges.contains(where: {
                    print("$0.maxFrameDuration.seconds > Double(fps.value)")
                    print($0.maxFrameRate)
                    return $0.maxFrameRate >= Double(fps.value)
                })
                print("format.highResolutionStillImageDimensions.height")
                print(format.highResolutionStillImageDimensions.height)
                print(VideoSettings.resolution.height)
                let containsResolution =
                    format.highResolutionStillImageDimensions.height >=
                        Int32(VideoSettings.resolution.height)
                return containsTimeRange && containsResolution
            })
            return formats.first
        }
    }
    static func updateFps(to device: AVCaptureDevice) {
        do {
            let formats = device.formats as! Array<AVCaptureDevice.Format>
            if let activeFormat = activeFormat(formats, fps) {
                try device.lockForConfiguration()
                device.activeFormat = activeFormat
                device.activeVideoMinFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps.value))
                device.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: CMTimeScale(fps.value))
                device.unlockForConfiguration()
            }
        } catch {
            return
        }
    }
    static func availableFPS(completion: ([FrameRate]) -> Void) {
        let formats = AVCaptureDevice.videoDevice(.back).formats as! Array<AVCaptureDevice.Format>
        var fpsAvailable: [FrameRate] = []
        FrameRate.allValues.forEach {
            if activeFormat(formats, $0) != nil { fpsAvailable.append($0) }
        }
        completion(fpsAvailable)
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
    var preset: (AVCaptureDevice) -> String {
        return { device in
            let isFrontCamera = device.position == .front
            switch self {
            case .sevenHundred:
                return AVOutputSettingsPreset1280x720
            case .oneThousand:
                return isFrontCamera ? AVOutputSettingsPreset1920x1080 : AVCaptureSessionPreset1280x720
            case .fourThousand:
                return isFrontCamera ?
                AVOutputSettingsPreset3840x2160 : AVCaptureSessionPreset1280x720
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
    case fifty
    case sixty
    case oneHundredTwenty
    case twoHundredforty

    static var allValues: [FrameRate] = [.twentyFive, .thirty, .fifty,
                                         .sixty, .oneHundredTwenty, twoHundredforty]
    var defaultsKey: String {
        return "VideoSettingsFrameRate"
    }
    
    var value: NSNumber {
        switch self {
        case .twentyFive: return 25
        case .thirty: return 30
        case .fifty: return 50
		case .sixty: return 60
        case .oneHundredTwenty: return 120
        case .twoHundredforty: return 240
        }
    }
}
