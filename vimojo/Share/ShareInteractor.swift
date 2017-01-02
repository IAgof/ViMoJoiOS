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
        let realmProject = ProjectRealmRepository().getProjectByUUID(uuid: actualProject.uuid)
        
        guard let modDate = actualProject.modificationDate else{
            exportVideoAction()
            return
        }
        
        guard let exportDate = realmProject?.exportDate else{
            exportVideoAction()
            return
        }
        
        guard let exportPath = realmProject?.getExportedPath() else{
            exportVideoAction()
            return
        }
        
        if modDate.isGreaterThanDate(dateToCompare: exportDate){
            exportVideoAction()
        }else{
            if FileManager.default.fileExists(atPath: exportPath){
                let exportURL = URL(fileURLWithPath: exportPath)
                self.delegate?.setPlayerUrl(videoURL: exportURL)
            }else{
                print("File doesn't exist")
                exportVideoAction()
            }
        }

    }
    
    func exportVideoAction(){
        guard let actualProject = project else{return}
        
        if let exportPath = actualProject.getExportedPath(){
            if FileManager.default.fileExists(atPath: exportPath){
                let exportURL = URL(fileURLWithPath: exportPath)
                Utils().removeFileFromURL(exportURL)
            }
        }
        
        let exporter = ExporterInteractor.init(project: actualProject)
        exporter.exportVideos({
            exportURL in
            print("Export path response = \(exportURL)")
            self.moviePath = exportURL.absoluteString
            ProjectRealmRepository().update(item: actualProject)
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
        guard let actualProject = project else{return}

        if let exportPath = actualProject.getExportedPath(){
             let sharePaths = ShareVideoPath(cameraRollPath: moviePath, documentsPath: exportPath)
            self.socialNetworks[indexPath.item].action.share(sharePaths)
        }
    }
    
    func postToYoutube(_ token:String){
        for socialNetwork in socialNetworks{
            if let action = socialNetwork.action as? ShareYoutubeInteractor{
                action.postVideoToYouTube(token, callback: {
                result in
                    print("result")
                    print(result)
                })
            }
        }
    }
    
    func getShareExportURL() -> URL? {
        guard let exportPath = project?.getExportedPath() else{
            return nil
        }
        
        return URL(fileURLWithPath: exportPath)
    }
}

extension ShareInteractor:ShareActionDelegate{
    func executeFinished(){
        
    }
}
