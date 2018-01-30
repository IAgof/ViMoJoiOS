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

	static func loadValues() {
		cameraStatus = CameraStatus(rawValue: defaults.integer(forKey: cameraStatus.defaultsKey)) ?? .cameraPro
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
