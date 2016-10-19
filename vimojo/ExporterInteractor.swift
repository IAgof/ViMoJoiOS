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
        
        guard let mixComposition = GetActualProjectAVCompositionUseCase().getComposition(project!).mutableComposition else {return}
        let videoComposition = AVMutableVideoComposition(propertiesOfAsset: mixComposition)

        // 4 - Get path
        let url = NSURL(fileURLWithPath: exportPath)
        
        // 5 - Create Exporter
        ApplyTextOverlayToVideoCompositionUseCase(project: project!).applyVideoOverlayAnimation(videoComposition,
                                                                                                mutableComposition: mixComposition,
                                                                                                size: videoComposition.renderSize)
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: exportedPresetQuality)
        exporter!.outputURL = url
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        exporter!.videoComposition = videoComposition
        
        // 6 - Perform the Export
        exporter!.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.clipDuration = GetActualProjectAVCompositionUseCase.sharedInstance.compositionInSeconds
                
                Utils().debugLog("la duracion del clip es \(self.clipDuration)")
                completionHandler(exportPath,self.clipDuration)

                ExportedAlbum.sharedInstance.saveVideo(NSURL.init(fileURLWithPath: exportPath))
            })
        }
    }
    

}