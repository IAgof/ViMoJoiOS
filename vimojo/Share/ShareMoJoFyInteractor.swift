//
//  ShareMoJoFyInteractor.swift
//  vimojo
//
//  Created by Jesus Huerta on 12/09/2017.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import Alamofire
import VideonaProject

class ShareMoJoFyInteractor{
	var mediaPath:String?
	var shareProject: Project
	
	init(shareProject project:Project){
		self.shareProject = project
	}
	
	// https://github.com/Alamofire/Alamofire#uploading-data-to-a-server
	func share(_ sharePath: ShareVideoPath) {
		trackShare()
		
		mediaPath = sharePath.documentsPath
	}
	
	func postVideoToMoJoFy(callback: @escaping (Bool) -> Void) {
		//        let token:String = "xxxxx"
		//        let headers = ["Authorization": "Bearer \(token)"]
		
		guard let path = mediaPath else {return}
		guard let videoData = try? Data.init(contentsOf: URL(fileURLWithPath: path)) else { return }
		//        let urlRequest = try! URLRequest(url: "http://35.195.141.208/media", method: .post, headers: headers)
		let urlRequest = "http://35.195.141.208/media"
		
		Alamofire.upload(
			multipartFormData: { multipartFormData in
				multipartFormData.append(videoData, withName: "video.mp4")
		},
			to: urlRequest,
			encodingCompletion: { encodingResult in
				switch encodingResult {
				case .success(let upload, _, _):
					upload.responseJSON { response in
						print(response)
						callback(true)
						
						let message = ShareConstants.UPLOAD_SUCCESFULL
						ShareUtils().setAlertCompletionMessageOnTopView(socialName: "MoJoFy", message: message)
					}
				case .failure(_):
					callback(false)
					let message = ShareConstants.UPLOAD_FAIL
					ShareUtils().setAlertCompletionMessageOnTopView(socialName: "MoJoFy", message: message)
				}
		}
		)
	}
	
	func trackShare() {
		ViMoJoTracker.sharedInstance.trackVideoShared("ViMoJoFy",
		                                              videoDuration: shareProject.getDuration(),
		                                              numberOfClips: shareProject.getVideoList().count)
	}
}


