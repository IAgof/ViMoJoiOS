//
//  ExporterInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject
import VideonaProject

class ExporterInteractor:NSObject{
    var clipDuration = 0.0
    var project:Project?
    var exportSession:AVAssetExportSession?
    
    init(project:Project) {
        super.init()
        self.project = project
    }
    
    func exportVideos(_ completionHandler:@escaping (_ url:URL?,_ failed:Bool)->Void) {

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let exportPath = (documentDirectory as NSString).appendingPathComponent("\(Utils().giveMeTimeNow())_VimojoClip_exported.m4v")

        let videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project!)
        var videoComposition = videonaComposition.videoComposition
        
        guard let mutableComposition = videonaComposition.mutableComposition else {return}
        
        // 4 - Get path
        let url = URL(fileURLWithPath: exportPath)
        
        // 5 - Create Exporter
        if (videoComposition == nil){
            videoComposition = AVMutableVideoComposition(propertiesOf: mutableComposition)
        }
        guard let actualProject = project else{return}
        
        ApplyTextOverlayToVideoCompositionUseCase(project: actualProject, videonaComposition: videonaComposition).applyVideoOverlayAnimation()
        var exportQuality = AVAssetExportPresetHighestQuality
        
        if let projectQuality = project?.getProfile().getQuality(){
            exportQuality = AVQualityParse().parseResolutionsToInteractor(textResolution: projectQuality)
        }
        
        exportSession = AVAssetExportSession(asset: mutableComposition, presetName: exportQuality)
        exportSession!.outputURL = url
        exportSession!.outputFileType = AVFileTypeQuickTimeMovie
        exportSession!.shouldOptimizeForNetworkUse = true
        
        if (videoComposition != nil){
            exportSession!.videoComposition = videoComposition
        }
        
        if let audioMix = videonaComposition.audioMix{
            exportSession!.audioMix = audioMix
        }
        
        // 6 - Perform the Export
        exportSession?.exportAsynchronously(completionHandler: {
            DispatchQueue.main.async(execute: { () -> Void in
                if self.exportSession?.status == .completed{
                    ExportedAlbum.sharedInstance.saveVideo(url,completion:{
                        videoURL in

                        self.project?.setExportedPath(path: exportPath)
                        if let project = self.project {
                            ViMoJoTracker.sharedInstance.sendExportedVideoMetadataTracking(project.getDuration(),
                                                                                           numberOfClips: project.getVideoList().count)
                        }
                        completionHandler(videoURL,false)
                    })
                }else{
                    completionHandler(nil,true)
                }
            })
        })
    }
}
