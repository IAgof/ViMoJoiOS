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
    
    func setShareMoviePath(_ moviePath: String) {
        self.moviePath = moviePath
    }
    
    func getProject() -> Project {
        return project!
    }
    func exportVideo() {
        guard let actualProject = project else{return}
        
        let exporter = ExporterInteractor.init(project: actualProject)
        exporter.exportVideos({
            exportURL in
            print("Export path response = \(exportURL)")
            self.delegate?.setPlayerUrl(videoURL: exportURL)
        })
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
    
    func shareVideo(_ indexPath: IndexPath, videoPath: String) {
        if let videoURL = NSURL(string: videoPath){
            GetPHAssetFromUrl().PHAssetForFileURL(url:videoURL, completion: {
                phasset in
                
                ExportTemporalVideoToShare().exportVideoAsset(phasset, completion: {
                    temporalVideo in
                    self.socialNetworks[indexPath.item].action.share(temporalVideo.absoluteString)
                })
            })
        }
    }
    
    func postToYoutube(_ token:String){
        shareYoutubeInteractor?.postVideoToYouTube(token,callback: { (result) -> () in
            Utils().debugLog("result \(result)")
        })
    }
}

extension ShareInteractor:ShareActionDelegate{
    func executeFinished(){
        
    }
}
