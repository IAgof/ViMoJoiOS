//
//  DetailProjectFoundToDetailProjectViewModelMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class DetailProjectFoundToDetailProjectViewModelMapper: Mapper {
    public typealias From = DetailProjectFound
    public typealias To = DetailProjectViewModel

    var quality: String!
    var duration: Double!

    func map(from: DetailProjectFound) -> DetailProjectViewModel {
        quality = from.quality
        duration = from.duration

        let durationString = getStringByKeyFromDetailProject(key: "duration_label").appending(Utils().hourToString(duration))
        let sizeString = getStringByKeyFromDetailProject(key: "size_label").appending(sizeFormatter(number: Float(from.size)))
        let qualityString = getStringByKeyFromDetailProject(key: "quality_label").appending(qualityFormatter(quality: quality))
        let formatString = getStringByKeyFromDetailProject(key: "format_label").appending(from.format)
        let bitrateString = getStringByKeyFromDetailProject(key: "bitrate_label").appending(bitRateFormatter(number: from.bitrate))
        let frameRateString = getStringByKeyFromDetailProject(key: "frame_rate_label").appending(frameRateFormatter(number: from.frameRate))

        return DetailProjectViewModel(thumbImage: from.thumbImage,
                                      projectName: from.projectName,
                                      duration: durationString,
                                      size: sizeString,
                                      quality: qualityString,
                                      format: formatString,
                                      bitrate: bitrateString,
                                      frameRate: frameRateString)
    }

    private func getStringByKeyFromDetailProject(key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: "DetailProject")
    }

    func numberToMega(number: Float) -> Int {
        let result: Int = Int(number)/1024/1024

        return result
    }

    func numberToKilo(number: Float) -> Int {
        let result: Int = Int(number)/1024

        return result
    }

    func bitRateFormatter(number: Float) -> String {
        var number = number

        if number == 0 {
            number = EstimationByQualityAndDuration(quality: self.quality,
                                                    duration: self.duration).bitRate
        }

        let megaNumber = numberToMega(number: number)
        if megaNumber > 0 {
            return "\(megaNumber) Mb/s"
        } else {
            return "\(numberToKilo(number: number)) Kb/s"
        }

    }

    func sizeFormatter(number: Float) -> String {
        var number = number

        if number == 0 {
            number = EstimationByQualityAndDuration(quality: self.quality,
                                                    duration: self.duration).size
        }
        let megaNumber = numberToMega(number: number)
        if megaNumber > 0 {
            return "\(megaNumber) Mb"
        } else {

            return "\(numberToKilo(number: number)) Kb"
        }
    }

    func frameRateFormatter(number: Float) -> String {
        if number != 0 {
            return "\(Int(number.rounded())) fps"
        } else {
            return "\(30) fps"
        }
    }

    func qualityFormatter(quality: String) -> String {
        return AVResolutionParse().parseResolutionToView(quality)
    }
}
