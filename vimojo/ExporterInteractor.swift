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
import VideonaPlayer

class ExporterInteractor:NSObject{
    var clipDuration = 0.0
    var exportedPresetQuality:String!
    var project:Project?
    var exportSession:AVAssetExportSession?
    
    init(project:Project) {
        super.init()
        exportedPresetQuality = initQuality()
        self.project = project
    }

    func initQuality()->String{
        var quality = AVAssetExportPresetHighestQuality
        //Get resolution
        if let getFromDefaultQuality = UserDefaults.standard.string(forKey: SettingsConstants().SETTINGS_QUALITY){
            quality = AVQualityParse().parseResolutionsToInteractor(textResolution: getFromDefaultQuality)
        }
        return quality
    }

    //Merge videos in VideosArray and export to Documents folder and PhotoLibrary
    func getNewPathToExport()->String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let exportPath = (documentDirectory as NSString).appendingPathComponent("mergeVideona-\(Utils().giveMeTimeNow()).m4v")
        
        return exportPath
    }
    
    func exportVideos(_ completionHandler:@escaping (URL)->Void) {
//        project?.setExportedPath()
        
//        guard let exportPath = project?.getExportedPath() else {return}
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

        ApplyTextOverlayToVideoCompositionUseCase(project: project!).applyVideoOverlayAnimation(videoComposition!,
                                                                                                mutableComposition: mutableComposition,
                                                                                                size: videoComposition!.renderSize)
        
        exportSession = AVAssetExportSession(asset: mutableComposition, presetName: exportedPresetQuality)
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
                        completionHandler(videoURL)
                    })
                }
            })
        })
    }
}
