//
//  MusicProvider.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class MusicProvider: NSObject {
    static let sharedInstance = MusicProvider()
    
    var localMusic = Array<Music>()
    
    override init() {
        super.init()
        self.populateLocalMusic()
    }
    
    func retrieveLocalMusic() -> Array<Music>{
        if (localMusic.count == 0){
            populateLocalMusic()
        }
        
    return localMusic;
    }
    
    func getMusicByTitle(title:String)->Music?{
        for music in localMusic{
            if music.getTitle() == title{
                return music
            }
        }
        return nil
    }
}
