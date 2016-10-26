//
//  ShareInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

class ShareInteractor: NSObject,ShareInteractorInterface {

    var delegate:ShareInteractorDelegate?
    var moviePath:String = ""
    var shareYoutubeInteractor:ShareYoutubeInteractor?
    var project:Project?
    var socialNetworks:[SocialNetwork] = []
    
    func setShareMoviePath(moviePath: String) {
        self.moviePath = moviePath
    }
    
    func getProject() -> Project {
        return project!
    }
    
    func findSocialNetworks(){
        socialNetworks = SocialNetworkProvider().getSocialNetworks(self)
        
        var shareViewModelObjects:[ShareViewModel] = []
        
        for socialNetwork in socialNetworks{
            guard let iconImage = UIImage(named: socialNetwork.iconId)else{
                print("Share icon image not found")
                return
            }
            guard let iconImagePressed = UIImage(named: socialNetwork.iconIdPressed)else{
                print("Share icon pressed image not found")
                return
            }
            
            shareViewModelObjects.append(ShareViewModel(icon: iconImage ,
                                           iconPressed: iconImagePressed,
                                           title: socialNetwork.title))
        }
        
        delegate?.setShareObjectsToView(shareViewModelObjects)
    }
    
    func shareVideo(indexPath: NSIndexPath, videoPath: String) {
        socialNetworks[indexPath.item].action.share(videoPath)
    }
    
    func postToYoutube(token:String){
        shareYoutubeInteractor?.postVideoToYouTube(token,callback: { (result) -> () in
            Utils().debugLog("result \(result)")
        })
    }
}

extension ShareInteractor:ShareActionDelegate{
    func executeFinished(){
        
    }
}