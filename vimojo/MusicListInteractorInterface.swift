//
//  MusicListInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation


protocol MusicListInteractorInterface {
    func getMusicList()
    func getVideoComposition()

    func setMusicToProject(index:Int)
    func hasMusicSelectedInProject()->Bool
    func getMusicDetailParams(index:Int)

    func getMusic()
}

protocol MusicListInteractorDelegate {
    func setMusicModelList(list:[MusicViewModel])
    func setMusicDetailParams(title:String,
                              author:String,
                              image:UIImage)
    func setVideoComposition(composition:AVMutableComposition)
}