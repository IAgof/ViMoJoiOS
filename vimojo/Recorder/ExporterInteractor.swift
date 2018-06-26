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
enum Response<T> {
    case error(Error)
    case success(T)
}
class ExporterInteractor: NSObject {
    var clipDuration = 0.0
    var project: Project?
    var exportSession: AVAssetExportSession?
    enum ExportError: Error {
        case cancelled
        case failed
        case unknown
        var localizedDescription: String {
            switch self {
            case .cancelled: return "Cancel error".localized(.share)
            case .failed: return "Failed exporting video, please check storage size".localized(.share)
            case .unknown: return "Unknown error".localized(.share)
            }
        }
    }
    init(project: Project) {
        super.init()
        self.project = project
    }
    func export( completion: @escaping (Response<URL>) -> Void ) {
        
        guard let project = project else {
            completion(.error(ExportError.unknown))
            return
        }
        let videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        guard let mutableComposition = videonaComposition.mutableComposition else {
            completion(.error(ExportError.unknown))
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
            guard let status = self.exportSession?.status else {return}
            print("----------------------Status------------------------")
            print("-----------------\(status.description)--------------")
            switch status {
            case .failed:
                completion(.error(ExportError.failed))
            case .unknown:
                completion(.error(ExportError.unknown))
            case .cancelled:
                completion(.error(ExportError.cancelled))
            case .completed:
                ExportedAlbum.sharedInstance.saveVideo(url, completion: {
                    videoURL in
                    self.project?.setExportedPath(path: exportPath)
                    if let project = self.project {
                        ViMoJoTracker.sharedInstance.sendExportedVideoMetadataTracking(project.getDuration(),
                                                                                       numberOfClips: project.getVideoList().count)
                    }
                    completion(.success(videoURL))
                })
            case .waiting, .exporting:
                print("Export WAITING or EXPORTING")
                break
            }
        })
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

extension AVAssetExportSessionStatus {
    var description: String {
        switch self {
        case .cancelled: return "Cancelled"
        case .completed: return "Completed"
        case .exporting: return "Exporting"
        case .failed: return "Failed"
        case .unknown: return "Unknown"
        case .waiting: return "Waiting"
        }
    }
}
