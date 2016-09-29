//
//  AddWatermarkUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import AssetsLibrary

class AddWatermarkUseCase: NSObject {
    enum QUWatermarkPosition {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
        case Default
    }
    
    func addWatermark(video videoAsset:AVAsset,
                            watermarkText text : String!,
                                          imageName name : String!,
                                                    saveToLibrary flag : Bool,
                                                                  watermarkPosition position : QUWatermarkPosition,
                                                                                    completion : ((status : AVAssetExportSessionStatus!,session: AVAssetExportSession!,savePath:String!) -> ())?) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            let mixComposition = AVMutableComposition()
            
            // 2 - Create video tracks
            let compositionVideoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let clipVideoTrack = videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0]
            do{
                try compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), ofTrack: clipVideoTrack, atTime: kCMTimeZero)
            }catch{
                
            }
            clipVideoTrack.preferredTransform
            
            // Video size
            let videoSize = clipVideoTrack.naturalSize
            
            // sorts the layer in proper order and add title layer
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height)
            videoLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height)
            parentLayer.addSublayer(videoLayer)
            
            if text != nil {
                // Adding watermark text
                let titleLayer = CATextLayer()
                titleLayer.backgroundColor = UIColor.redColor().CGColor
                titleLayer.string = text
                titleLayer.font = "Helvetica"
                titleLayer.fontSize = 15
                titleLayer.alignmentMode = kCAAlignmentCenter
                titleLayer.bounds = CGRectMake(0, 0, videoSize.width, videoSize.height)
                parentLayer.addSublayer(titleLayer)
                
                print("\(videoSize.width)")
                print("\(videoSize.height)")
            } else if name != nil {
                // Adding image
                let watermarkImage = UIImage(named: name)
                let imageLayer = CALayer()
                imageLayer.contents = watermarkImage?.CGImage
                
                var xPosition : CGFloat = 0.0
                var yPosition : CGFloat = 0.0
                let imageSize = videoSize.width
                
                switch (position) {
                case .TopLeft:
                    xPosition = 0
                    yPosition = 0
                    break
                case .TopRight:
                    xPosition = videoSize.width - imageSize
                    yPosition = 0
                    break
                case .BottomLeft:
                    xPosition = 0
                    yPosition = videoSize.height - imageSize
                    break
                case .BottomRight, .Default:
                    xPosition = videoSize.width - imageSize
                    yPosition = videoSize.height - imageSize
                    break
                }
                
                print("\(xPosition)")
                print("\(yPosition)")
                
                imageLayer.frame = CGRectMake(xPosition, yPosition, videoSize.width,videoSize.height)
                imageLayer.opacity = 0.65
                parentLayer.addSublayer(imageLayer)
            }
            
            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(1, 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
            
            /// instruction
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mixComposition.duration)
            
            let videoTrack = mixComposition.tracksWithMediaType(AVMediaTypeVideo)[0] as AVAssetTrack
            
            let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero,videoAsset.duration),
                    ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                    atTime: kCMTimeZero)
            }catch{
                print("error introducing audiotrack")
            }
            
            //            let layerInstruction = self.videoCompositionInstructionForTrack(compositionVideoTrack, asset: videoAsset)
            
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
            
            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]
            
            // 4 - Get path
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .LongStyle
            dateFormatter.timeStyle = .ShortStyle
            let savePath = (documentDirectory as NSString).stringByAppendingPathComponent("\(Utils().giveMeTimeNow())videonaClip.m4v")
            
            let url = NSURL(fileURLWithPath: savePath)
            
            // 5 - Create Exporter
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = url
            exporter!.outputFileType = AVFileTypeQuickTimeMovie
            exporter!.shouldOptimizeForNetworkUse = true
            exporter!.videoComposition = videoComp
            
            // 6 - Perform the Export
            exporter!.exportAsynchronouslyWithCompletionHandler() {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if exporter!.status == AVAssetExportSessionStatus.Completed {
                        let outputURL = exporter!.outputURL
                        if flag {
                            // Save to library
                            let library = ALAssetsLibrary()
                            if library.videoAtPathIsCompatibleWithSavedPhotosAlbum(outputURL) {
                                library.writeVideoAtPathToSavedPhotosAlbum(outputURL,
                                    completionBlock: { (assetURL:NSURL!, error:NSError!) -> Void in
                                        completion!(status: AVAssetExportSessionStatus.Completed, session: exporter,savePath:savePath)
                                })
                            }
                        } else {
                            // Dont svae to library
                            completion!(status: AVAssetExportSessionStatus.Completed, session: exporter,savePath:savePath)
                        }
                        
                    } else {
                        // Error
                        completion!(status: exporter!.status, session: exporter,savePath:nil)
                    }
                })
            }
        })
    }

}