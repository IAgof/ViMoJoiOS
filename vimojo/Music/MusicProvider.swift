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
    
    private var localMusic = Array<Music>()
    
    func retrieveLocalMusic() -> Array<Music>{
        if (localMusic.count == 0){
            populateLocalMusic()
        }
        
    return localMusic;
   
    }
    
    func populateLocalMusic() {
//        localMusic.append(Music(title: "Vadodora",
//            author: "Kevin Macleod",
//            iconResourceId: "imagebutton_music_background_bollywood",
//            musicResourceId: "audio_bollywood"))
//        
//        localMusic.append(Music(title: "Airplane Mod Instrumental",
//            author: "James Woodward",
//            iconResourceId: "imagebutton_music_background_rock",
//            musicResourceId: "audio_rock"))
//        
//        localMusic.append(Music(title: "Impact Prelude",
//            author: "Kevin Macleod",
//            iconResourceId: "imagebutton_music_background_ambient",
//            musicResourceId: "audio_ambiental"))
//        
//        localMusic.append(Music(title: "Monkeys Spinning Monkeys",
//            author: "Kevin Macleod",
//            iconResourceId: "imagebutton_music_background_jazz",
//            musicResourceId: "audio_clasica_flauta"))
//        
//        localMusic.append(Music(title: "Don't Close Your Eyes",
//            author: "Josh Woodward",
//            iconResourceId: "imagebutton_music_background_folk",
//            musicResourceId: "audio_folk"))
//        
//        localMusic.append(Music(title: "Super Psyched for Your Birthday",
//            author: "The Danimals",
//            iconResourceId: "imagebutton_music_background_birthday",
//            musicResourceId: "audio_birthday"))
//        
//        localMusic.append(Music(title: "I Dunno",
//            author: "Grapes",
//            iconResourceId: "imagebutton_music_background_hiphop",
//            musicResourceId: "audio_hiphop"))
//        
//        localMusic.append(Music(title: "The Last Slice of Pecan Pie",
//            author: "Josh Woodward",
//            iconResourceId: "imagebutton_music_background_classic",
//            musicResourceId: "audio_clasica_piano"))
    }
}