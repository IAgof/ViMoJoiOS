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

	static var cameraSimplePro: CameraStatus = .cameraPro {
		didSet {
			defaults.set(cameraSimplePro.rawValue, forKey: cameraSimplePro.defaultsKey)
		}
	}

	static func loadValues() {
		cameraSimplePro = CameraStatus(rawValue: defaults.integer(forKey: cameraSimplePro.defaultsKey)) ?? .cameraPro
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
