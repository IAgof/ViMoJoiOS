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

class ExporterInteractor: NSObject {
    var clipDuration = 0.0
    var project: Project?
    var exportSession: AVAssetExportSession?
    
    init(project: Project) {
        super.init()
        self.project = project
    }
    func exportVideos(_ completionHandler:@escaping (_ url: URL?, _ failed: Bool) -> Void) {
 
        guard let project = project else {
            completionHandler(nil, true)
            return
        }
        let videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        guard let mutableComposition = videonaComposition.mutableComposition else {
            completionHandler(nil, true)
            return
        }
        let videoComposition = videonaComposition.videoComposition ?? AVMutableVideoComposition(propertiesOf: mutableComposition)
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let exportPath = (documentDirectory as NSString).appendingPathComponent("\(Utils().giveMeTimeNow())_VimojoClip_exported.m4v")
        

        // 4 - Get path
        let url = URL(fileURLWithPath: exportPath)
        
        // 5 - Create Exporter
        ApplyTextOverlayToVideoCompositionUseCase(project: project, videonaComposition: videonaComposition).applyVideoOverlayAnimation()
        var exportQuality = AVAssetExportPresetHighestQuality
        exportQuality = AVQualityParse().parseResolutionsToInteractor(textResolution: project.getProfile().getQuality())
        
        exportSession = AVAssetExportSession(asset: mutableComposition, presetName: exportQuality)
        exportSession?.outputURL = url
        exportSession?.outputFileType = AVFileTypeQuickTimeMovie
        exportSession?.videoComposition = videoComposition
        
        if let audioMix = videonaComposition.audioMix {
            exportSession?.audioMix = audioMix
        }
        // 6 - Perform the Export
        exportSession?.exportAsynchronously(completionHandler: {
            if self.exportSession?.status == .completed {
                ExportedAlbum.sharedInstance.saveVideo(url, completion: {
                    videoURL in
                    self.project?.setExportedPath(path: exportPath)
                    if let project = self.project {
                        ViMoJoTracker.sharedInstance.sendExportedVideoMetadataTracking(project.getDuration(),
                                                                                       numberOfClips: project.getVideoList().count)
                    }
                    completionHandler(videoURL, false)
                })
            } else if self.exportSession?.status == .cancelled {
                completionHandler(nil, false)
            } else {
                completionHandler(nil, true)
            }
        })
    }
}

