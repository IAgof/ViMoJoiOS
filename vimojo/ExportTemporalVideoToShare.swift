//
//  ExportTemporalVideoToShare.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 20/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos

class ExportTemporalVideoToShare {

    func exportVideoAsset(_ asset: PHAsset, completion:@escaping (URL) -> Void) {
        let filename = "VimojoTemporalExport.m4v"

        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            var fileurl = try documentsUrl.absoluteString.appending(filename).asURL()
            print("exporting video to ", fileurl)
            fileurl = fileurl.standardizedFileURL

            let options = PHVideoRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true

            do {
                try FileManager.default.removeItem(at: fileurl)
            } catch {

            }

            PHImageManager.default().requestExportSession(forVideo: asset, options: options, exportPreset: AVAssetExportPresetHighestQuality) {
                (exportSession: AVAssetExportSession?, _) in

                if exportSession == nil {
                    print("COULD NOT CREATE EXPORT SESSION")
                    return
                }
                exportSession!.outputURL = fileurl
                exportSession!.outputFileType = AVFileTypeQuickTimeMovie

                print("GOT EXPORT SESSION")
                exportSession!.exportAsynchronously {
                    print("EXPORT DONE")
                    completion(fileurl)
                }
            }
        } catch {
            // something may happend here, like no disk space

            print("No Disk space")
        }
    }
}
