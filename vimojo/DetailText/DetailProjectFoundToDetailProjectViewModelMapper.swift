//
//  DetailProjectFoundToDetailProjectViewModelMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

class DetailProjectFoundToDetailProjectViewModelMapper:Mapper {
    public typealias From = DetailProjectFound
    public typealias To = DetailProjectViewModel

    func map(from: DetailProjectFound) -> DetailProjectViewModel {
        let durationString = getStringByKeyFromDetailProject(key: "duration_label").appending(from.duration)
        let sizeString = getStringByKeyFromDetailProject(key: "size_label").appending("\(numberToMega(number: Float(from.size))) Mb")
        let qualityString = getStringByKeyFromDetailProject(key: "quality_label").appending(from.quality)
        let formatString = getStringByKeyFromDetailProject(key: "format_label").appending(from.format)
        let bitrateString = getStringByKeyFromDetailProject(key: "bitrate_label").appending("\(numberToMega(number:from.bitrate)) Mb/s")
        let frameRateString = getStringByKeyFromDetailProject(key: "frame_rate_label").appending("\(Int(from.frameRate)) fps")
        
        return DetailProjectViewModel(thumbImage: from.thumbImage,
                                      projectName: from.projectName,
                                      duration: durationString,
                                      size: sizeString,
                                      quality: qualityString,
                                      format: formatString,
                                      bitrate: bitrateString,
                                      frameRate: frameRateString)
    }
    
    private func getStringByKeyFromDetailProject(key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "DetailProject")
    }
    
    func numberToMega(number:Float)->Int{
        let result:Int = Int(number)/1024/1024
        
        return result
    }
}
