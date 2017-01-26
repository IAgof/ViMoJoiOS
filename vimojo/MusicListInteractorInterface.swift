//
//  MusicListInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

protocol MusicListInteractorInterface {
    func getMusicList()
    func getVideoComposition()

    func setMusicToProject(_ index:Int)
    func hasMusicSelectedInProject()->Bool
    func getMusicDetailParams(_ index:Int)

    func getMusic()
    func updateAudioMix(withParameter param:MixAudioModel)
}

protocol MusicListInteractorDelegate {
    func setMusicModelList(_ list:[MusicViewModel])
    func setMusicDetailParams(_ title:String,
                              author:String,
                              image:UIImage)
    func setVideoComposition(_ composition: VideoComposition)
    func setAudioMix(audioMix value:AVAudioMix)
}
