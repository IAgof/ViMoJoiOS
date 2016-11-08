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
    
    init(project:Project) {
        super.init()
        exportedPresetQuality = initQuality()
        self.project = project
    }

    func initQuality()->String{
        var quality = AVAssetExportPresetHighestQuality
        //Get resolution
        if let getFromDefaultQuality = NSUserDefaults.standardUserDefaults().stringForKey(SettingsConstants().SETTINGS_QUALITY){
            quality = AVQualityParse().parseResolutionsToInteractor(getFromDefaultQuality)
        }
        return quality
    }

    //Merge videos in VideosArray and export to Documents folder and PhotoLibrary
    func getNewPathToExport()->String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let exportPath = (documentDirectory as NSString).stringByAppendingPathComponent("mergeVideona-\(Utils().giveMeTimeNow()).m4v")
        
        return exportPath
    }
    
    func exportVideos(completionHandler:(String,Double)->Void) {
        project?.setExportedPath()
        
        guard let exportPath = project?.getExportedPath() else {return}
        
        let videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project!)
        var videoComposition = videonaComposition.videoComposition
        guard let mutableComposition = videonaComposition.mutableComposition else {return}
        
        // 4 - Get path
        let url = NSURL(fileURLWithPath: exportPath)
        
        // 5 - Create Exporter
        if (videoComposition == nil){
            videoComposition = AVMutableVideoComposition(propertiesOfAsset: mutableComposition)
        }
        
        ApplyTextOverlayToVideoCompositionUseCase(project: project!).applyVideoOverlayAnimation(videoComposition!,
                                                                                                mutableComposition: mutableComposition,
                                                                                                size: videoComposition!.renderSize)
        
        let exporter = AVAssetExportSession(asset: mutableComposition, presetName: exportedPresetQuality)
        exporter!.outputURL = url
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        if (videoComposition != nil){
            exporter!.videoComposition = videoComposition
        }
        // 6 - Perform the Export
        exporter!.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.clipDuration = GetActualProjectAVCompositionUseCase().compositionInSeconds
                
                Utils().debugLog("la duracion del clip es \(self.clipDuration)")
                completionHandler(exportPath,self.clipDuration)
                
                ExportedAlbum.sharedInstance.saveVideo(NSURL.init(fileURLWithPath: exportPath))
            })
        }
    }
    

}