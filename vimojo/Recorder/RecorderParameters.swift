//
//  RecorderParameters.swift
//  vimojo
//
//  Created by Jesus Huerta on 23/11/2017.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import AVKit

struct RecorderParameters {
	let movieOutput: AVCaptureMovieFileOutput
	let activeInput: AVCaptureDeviceInput
	let outputURL: URL!
}
