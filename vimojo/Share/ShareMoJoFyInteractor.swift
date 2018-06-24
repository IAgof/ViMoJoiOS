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

class ShareMoJoFyInteractor: ShareActionInterface {
	var mediaPath:String?
	var shareProject: Project
    var delegate: ShareActionDelegate

    init(delegate: ShareActionDelegate,
         shareProject project: Project){
		self.shareProject = project
        self.delegate = delegate
	}
	
	// https://github.com/Alamofire/Alamofire#uploading-data-to-a-server
	func share(_ sharePath: ShareVideoPath) {
		trackShare()
		mediaPath = sharePath.documentsPath
        postVideoToMoJoFy(sharePath.documentsPath)
	}
	
	func postVideoToMoJoFy(_ fileName:String ) {
		
		let url = "http://35.195.141.208/media"
		
		let parameters = [String: AnyObject]()
		
		let headers: HTTPHeaders = [
			"Content-type": "multipart/form-data"
		]
		
		guard let path = mediaPath else { return }
		
		guard let videoData = try? Data.init(contentsOf: URL(fileURLWithPath: path)) else { return }
		
		Alamofire.upload(multipartFormData: { (multipartFormData) in
			for (key, value) in parameters {
				multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
			}
			
			multipartFormData.append(videoData, withName: "file", fileName: fileName, mimeType: "application/octet-stream")
			
		}, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
			switch result{
			case .success(let upload, _, _):
				upload.responseJSON { response in
					print(response)
					let message = ShareConstants.UPLOAD_SUCCESFULL
					ShareUtils().setAlertCompletionMessageOnTopView(socialName: "MoJoFy", message: message)
				}
			case .failure(_):
				let message = ShareConstants.UPLOAD_FAIL
				ShareUtils().setAlertCompletionMessageOnTopView(socialName: "MoJoFy", message: message)
			}
		}
	}
	
	func trackShare() {
		ViMoJoTracker.sharedInstance.trackVideoShared("ViMoJoFy",
		                                              videoDuration: shareProject.getDuration(),
		                                              numberOfClips: shareProject.getVideoList().count)
	}
}


