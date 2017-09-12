//
//  ShareVideoPath.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 22/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public struct ShareVideoPath {
    let cameraRollPath:String
    let documentsPath:String
	
	init(cameraRollPath:String, documentsPath:String) {
		self.cameraRollPath = cameraRollPath
		self.documentsPath = documentsPath
	}
	
	init (with path:String) {
		self.cameraRollPath = path
		self.documentsPath = path
	}
}
    
