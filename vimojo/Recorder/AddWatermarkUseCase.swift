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
import VideonaProject

class AddWatermarkUseCase: NSObject {
    enum QUWatermarkPosition {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case `default`
    }
    
    func addWatermark(video videoAsset: AVAsset,
                      watermarkText text: String!,
                      imageName name: String!,
                      saveToLibrary flag: Bool,
                      watermarkPosition position: QUWatermarkPosition,
                      completion : ((_ status: AVAssetExportSessionStatus?, _ session: AVAssetExportSession?, _ savePath: String?) -> Void)?) {
        
        DispatchQueue.global().async { () -> Void in
            // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
            let mixComposition = AVMutableComposition()
            
            // 2 - Create video tracks
            let compositionVideoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let clipVideoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
            do {
                try compositionVideoTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: clipVideoTrack, at: kCMTimeZero)
            } catch {
                
            }
            
            // Video size
            let videoSize = clipVideoTrack.naturalSize
            
            // sorts the layer in proper order and add title layer
            let parentLayer = CALayer()
            let videoLayer = CALayer()
            parentLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
            parentLayer.addSublayer(videoLayer)
            
            if text != nil {
                // Adding watermark text
                let titleLayer = CATextLayer()
                titleLayer.backgroundColor = UIColor.red.cgColor
                titleLayer.string = text
                titleLayer.font = "Helvetica" as CFTypeRef?
                titleLayer.fontSize = 15
                titleLayer.alignmentMode = kCAAlignmentCenter
                titleLayer.bounds = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
                parentLayer.addSublayer(titleLayer)
                
                print("\(videoSize.width)")
                print("\(videoSize.height)")
            } else if name != nil {
                // Adding image
                let watermarkImage = UIImage(named: name)
                let imageLayer = CALayer()
                imageLayer.contents = watermarkImage?.cgImage
                
                var xPosition: CGFloat = 0.0
                var yPosition: CGFloat = 0.0
                let imageSize = videoSize.width
                
                switch (position) {
                case .topLeft:
                    xPosition = 0
                    yPosition = 0
                    break
                case .topRight:
                    xPosition = videoSize.width - imageSize
                    yPosition = 0
                    break
                case .bottomLeft:
                    xPosition = 0
                    yPosition = videoSize.height - imageSize
                    break
                case .bottomRight, .default:
                    xPosition = videoSize.width - imageSize
                    yPosition = videoSize.height - imageSize
                    break
                }
                
                print("\(xPosition)")
                print("\(yPosition)")
                
                imageLayer.frame = CGRect(x: xPosition, y: yPosition, width: videoSize.width, height: videoSize.height)
                imageLayer.opacity = 0.65
                parentLayer.addSublayer(imageLayer)
            }
            
            let videoComp = AVMutableVideoComposition()
            videoComp.renderSize = videoSize
            videoComp.frameDuration = CMTimeMake(1, 30)
            videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
            
            /// instruction
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, mixComposition.duration)
            
            let videoTrack = mixComposition.tracks(withMediaType: AVMediaTypeVideo)[0] as AVAssetTrack
            
            let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            
            do {
                try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration),
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                               at: kCMTimeZero)
            } catch {
                print("error introducing audiotrack")
            }
            
            //            let layerInstruction = self.videoCompositionInstructionForTrack(compositionVideoTrack, asset: videoAsset)
            
            let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
            
            instruction.layerInstructions = [layerInstruction]
            videoComp.instructions = [instruction]
            
            // 4 - Get path
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let savePath = (documentDirectory as NSString).appendingPathComponent("\(Utils().giveMeTimeNow())videonaClip.m4v")
            
            let url = URL(fileURLWithPath: savePath)
            
            // 5 - Create Exporter
            let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
            exporter!.outputURL = url
            exporter!.outputFileType = AVFileTypeQuickTimeMovie
            exporter!.shouldOptimizeForNetworkUse = true
            exporter!.videoComposition = videoComp
            
            // 6 - Perform the Export
            exporter!.exportAsynchronously {
                DispatchQueue.main.async(execute: { () -> Void in
                    if exporter!.status == AVAssetExportSessionStatus.completed {
                        let outputURL = exporter!.outputURL
                        if flag {
                            // Save to library
                            let library = ALAssetsLibrary()
                            if library.videoAtPathIs(compatibleWithSavedPhotosAlbum: outputURL) {
                                library.writeVideoAtPath(toSavedPhotosAlbum: outputURL, completionBlock: {
                                    _, _ in
                                    completion!(AVAssetExportSessionStatus.completed, exporter, savePath)
                                })
                            }
                        } else {
                            // Dont svae to library
                            completion!(AVAssetExportSessionStatus.completed, exporter, savePath)
                        }
                        
                    } else {
                        // Error
                        completion!(exporter!.status, exporter, nil)
                    }
                })
            }
        }
    }
    
}
