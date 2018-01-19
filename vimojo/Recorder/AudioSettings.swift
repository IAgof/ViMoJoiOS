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
    static var format: AudioFormat = .mpeg4 {
        didSet {
            // TODO: Write to defaults
        }
    }
    // TODO: solve this, must not to be hardCoded
    private static var numberOfChannelsKey = 1
    static var sampleRateKey: AudioSampleRateKey = .fortyK {
        didSet {
            // TODO: Write to defaults
        }
    }
    static var bitRateKey: AudioBitRateKey = .sixtyFourK {
        didSet {
            // TODO: Write to defaults
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
    
    init() {
        // TODO: on creation load data from defaults
    }
}

enum AudioBitRateKey {
    case sixtyFourK
    
    var value: NSNumber {
        switch self {
        case .sixtyFourK: return 64000
        }
    }
}
enum AudioSampleRateKey {
    case fortyK
    
    var value: NSNumber {
        switch self {
        case .fortyK: return 44100.0
        }
    }
}
enum AudioFormat {
    case mpeg4
    
    var value: AudioFormatID {
        switch self {
        case .mpeg4: return kAudioFormatMPEG4AAC
        }
    }
}
