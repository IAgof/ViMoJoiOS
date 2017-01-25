//
//  DetailProjectInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import Photos
import AVFoundation

class DetailProjectInteractor:DetailProjectInteractorInterface {
    var delegate:DetailProjectInteractorDelegate?
    var videoUUID:String = ""
    var projectName: String = ""
    
    private struct VideoParameters {
        let bitrate:Float
        let frameRate:Float
    }
    
    func searchProjectParams() {
        if let project = ProjectRealmRepository().getProjectByUUID(uuid: videoUUID){
            let thumbImage = getProjectThumbnail(project: project)
            var exportedPath = ""
            
            if let path = project.getExportedPath(){
                exportedPath = path
            }
            
            let videoParameters = getVideoParams(filePath: exportedPath)
            
            let projectFoundParams = DetailProjectFound(thumbImage: thumbImage,
                                                        projectName: project.getTitle(),
                                                        size: getProjectSize(filePath:exportedPath),
                                                        duration: Utils().hourToString(project.getDuration()),
                                                        quality: project.getProfile().getQuality(),
                                                        format: "m4v",
                                                        bitrate: videoParameters.bitrate,
                                                        frameRate: videoParameters.frameRate)
            
            delegate?.projectFound(params: projectFoundParams)
        }
    }
    
    func getProjectThumbnail(project:Project)->UIImage{
        if let url = project.getVideoList().first?.videoURL{
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            
            var time = asset.duration
            time.value = min(time.value, 1)
            
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: imageRef)
            } catch {
                print("error")
            }
        }
        return UIImage(named: "activity_project_gallery_no_videos")!
    }
    
    func getProjectSize(filePath:String)->UInt64{
        if FileManager.default.fileExists(atPath: filePath){
            var fileSize : UInt64
            
            do {
                //return [FileAttributeKey : Any]
                let attr = try FileManager.default.attributesOfItem(atPath: filePath)
                fileSize = attr[FileAttributeKey.size] as! UInt64
                
                //if you convert to NSDictionary, you can get file size old way as well.
                let dict = attr as NSDictionary
                fileSize = dict.fileSize()
                
                return fileSize
            } catch {
                print("Error: \(error)")
                return 0
            }
        }else{
            return 0
        }
    }
    
    private func getVideoParams(filePath:String)->VideoParameters{
        if FileManager.default.fileExists(atPath: filePath){
            let url = URL(fileURLWithPath: filePath)
        let asset = AVAsset(url: url)
        
        if let videoTrack = asset.tracks(withMediaType: AVMediaTypeVideo).first{
            return VideoParameters(bitrate: videoTrack.estimatedDataRate, frameRate: videoTrack.nominalFrameRate)
        }else{
            return VideoParameters(bitrate: 0, frameRate: 0)
            }
        }else{return VideoParameters(bitrate: 0, frameRate: 0)}
    }
    
    func saveProjectName() {
        if let project = ProjectRealmRepository().getProjectByUUID(uuid: videoUUID){
            project.setTitle(projectName)
            
            ProjectRealmRepository().update(item: project)
        }
    }
}
