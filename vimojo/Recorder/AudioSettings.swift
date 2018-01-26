//
//  AudioSettings.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/1/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioSettings {
    static var defaults = UserDefaults.standard
    
    static var format: AudioFormat = .mpeg4 {
        didSet {
            defaults.set(format.value, forKey: format.defaultsKey)
        }
    }
    // TODO: solve this, must not to be hardCoded
    private static var numberOfChannelsKey = 1
    static var sampleRateKey: AudioSampleRateKey = .fortyK {
        didSet {
            defaults.set(sampleRateKey.value, forKey: sampleRateKey.defaultsKey)
        }
    }
    static var bitRateKey: AudioBitRateKey = .sixtyFourK {
        didSet {
            defaults.set(bitRateKey.value, forKey: bitRateKey.defaultsKey)
        }
    }
    
    public static var audioSettings: [String: Any] {
        return [
            AVFormatIDKey : format.value,
            AVNumberOfChannelsKey : numberOfChannelsKey,
            AVSampleRateKey : sampleRateKey.value,
            AVEncoderBitRateKey : bitRateKey.value
        ]
    }
    
    static func loadValues() {
        format = (defaults.object(forKey: format.defaultsKey) as? AudioFormat) ?? .mpeg4
        sampleRateKey = (defaults.object(forKey: sampleRateKey.defaultsKey) as? AudioSampleRateKey) ?? .fortyK
        bitRateKey = (defaults.object(forKey: bitRateKey.defaultsKey) as? AudioBitRateKey) ?? .sixtyFourK
    }
}

enum AudioBitRateKey {
    case sixtyFourK
    
    var defaultsKey: String {
        return "AudioSettingsAudioBitRateKey"
    }
    var value: NSNumber {
        switch self {
        case .sixtyFourK: return 64000
        }
    }
}
enum AudioSampleRateKey {
    case fortyK
    
    var defaultsKey: String {
        return "AudioSettingsAudioSampleRateKey"
    }
    var value: NSNumber {
        switch self {
        case .fortyK: return 44100.0
        }
    }
}
enum AudioFormat {
    case mpeg4
    
    var defaultsKey: String {
        return "AudioSettingsAudioFormat"
    }
    var value: AudioFormatID {
        switch self {
        case .mpeg4: return kAudioFormatMPEG4AAC
        }
    }
}
