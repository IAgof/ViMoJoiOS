//
//  ProjectListViewModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

struct ProjectListViewModel {
    let thumbImage: UIImage
    let title: String
    var date: String = ""
    let duration: String
    private let videoURL: URL?

    init(videoURL: URL?,
         title: String,
         date: Date,
         duration: Double) {
        self.title = title
        self.duration = ProjectListConstants.PROJECT_LIST_DURATION_PREFIX.appending(Utils().formatTimeToMinutesAndSeconds(duration))
        self.videoURL = videoURL

        self.thumbImage = #imageLiteral(resourceName: "activity_project_gallery_no_videos")

        let transformDate = formatDateToString(date: date)
        self.date = ProjectListConstants.PROJECT_LIST_DATE_PREFIX.appending("\n").appending(transformDate)
    }

    func getVideoThumbnail() -> UIImage {
        if let url = videoURL {
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

    private func formatDateToString(date: Date) -> String {
        if Locale.preferredLanguages.first == "es-ES"{
            return formatDateToEuropeFormatString(date: date)
        } else {
            return formatDateToAmericanFormatString(date: date)
        }
    }

    private func formatDateToAmericanFormatString(date: Date) -> String {
        let projectListFormatter = DateFormatter()
        projectListFormatter.dateFormat = "M-d-yy/HH:m"

        return projectListFormatter.string(from: date as Date)
    }

    private func formatDateToEuropeFormatString(date: Date) -> String {
        let projectListFormatter = DateFormatter()
        projectListFormatter.dateFormat = "d-M-yy/HH:m"

        return projectListFormatter.string(from: date as Date)
    }

}
