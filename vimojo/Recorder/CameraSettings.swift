//
//  CameraSettings.swift
//  vimojo
//
//  Created by Jesus Huerta on 26/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

public class CamSettings {
	static var defaults = UserDefaults.standard

	static var cameraStatus: CameraStatus = .cameraPro {
		didSet {
			defaults.set(cameraStatus.rawValue, forKey: cameraStatus.defaultsKey)
		}
	}
    
    static var cameraPosition: CameraPosition = .back {
        didSet {
            defaults.set(cameraPosition.rawValue, forKey: cameraPosition.defaultsKey)
        }
    }

	static func loadValues() {
		cameraStatus = CameraStatus(rawValue: defaults.integer(forKey: cameraStatus.defaultsKey)) ?? .cameraPro
        cameraPosition = CameraPosition(rawValue: defaults.string(forKey: cameraPosition.defaultsKey)!) ?? .back
	}
}

enum CameraStatus: Int {
	case cameraPro = 0
	case cameraBasic

	var defaultsKey: String {
		return "CameraStatus"
	}
	var value: Int {
		switch self {
		case .cameraPro: return 0
		case .cameraBasic: return 1
		}
	}
}

enum CameraPosition: String {
    case back = "back"
    case front
    
    
    var defaultsKey: String {
        return "CameraPosition"
    }
    var value: String {
        switch self {
        case .back: return "back"
        case .front: return "front"
        }
    }
}
