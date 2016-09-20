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
    
    var moviePath:String = ""
    var shareYoutubeInteractor:ShareYoutubeInteractor?
    var project:Project?
    
    func setShareMoviePath(moviePath: String) {
        self.moviePath = moviePath
    }
    
    func getProject() -> Project {
        return project!
    }
    
    func findSocialNetworks()->(socialNetworkTitleArray:Array<String>, socialNetworkImageArray:Array<UIImage>,socialNetworkImagePressedArray:Array<UIImage>){
        let socialNetworks = SocialNetworkProvider().getSocialNetworks()
        
        let socialNetworkImage = self.setArraySocialNetworksUIImage(socialNetworks)
        let socialNetworkImagePressed = self.setArraySocialNetworksUIImagePressed(socialNetworks)
        let socialNetworkTitle = self.setArraySocialNetworksTitle(socialNetworks)
        
        return (socialNetworkTitle,socialNetworkImage,socialNetworkImagePressed)
    }
    
    func setArraySocialNetworksTitle(sNArray:Array<SocialNetwork>)->Array<String>{
        var titleArray = Array<String>()
        
        for title in sNArray{
            titleArray.append(title.getTitle())
        }
        return titleArray
    }
    
    func setArraySocialNetworksUIImage(sNArray:Array<SocialNetwork>)->Array<UIImage>{
        var imageArray = Array<UIImage>()
        
        for imageName in sNArray{
            let image = UIImage.init(named: imageName.getIconId())
            imageArray.append(image!)
        }
        
        return imageArray
    }
    func setArraySocialNetworksUIImagePressed(sNArray:Array<SocialNetwork>)->Array<UIImage>{
        var imageArray = Array<UIImage>()
        
        for imageName in sNArray{
            let image = UIImage.init(named: imageName.getIconIdPressed())
            imageArray.append(image!)
        }
        
        return imageArray
    }
    
    func shareVideo(socialNetworkTitle: String, videoPath: String) {
        
        switch socialNetworkTitle {
        case "Facebook":
            print("Share video on facebook")
            ShareFacebookInteractor(socialName: socialNetworkTitle).share()
        case "Instagram":
            print("Share video on Instagram")
            ShareInstagramInteractor(socialName: socialNetworkTitle).share()
        case "Twitter":
            print("Share video on Twitter")
            ShareTwitterInteractor(socialName: socialNetworkTitle).share()
        case "Whatsapp":
            print("Share video on Whatsapp")
            ShareWhatsappInteractor(socialName: socialNetworkTitle).share()
        case "Youtube":
            print("Share video on Youtube")
            dispatch_async(dispatch_get_main_queue(), {
                // update some UI
                self.shareYoutubeInteractor =  ShareYoutubeInteractor(socialName: socialNetworkTitle)
                self.shareYoutubeInteractor!.share()
            });
        default:
            print("No Social network")
            
        }
    }
    
    func postToYoutube(token:String){
        shareYoutubeInteractor?.postVideoToYouTube(token,callback: { (result) -> () in
            Utils().debugLog("result \(result)")
        })
    }
}