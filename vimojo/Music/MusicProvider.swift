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
    
    fileprivate var localMusic = Array<Music>()
    
    func retrieveLocalMusic() -> Array<Music>{
        if (localMusic.count == 0){
            populateLocalMusic()
        }
        
    return localMusic;
   
    }
    
    func populateLocalMusic() {
        localMusic.append(Music(title: "Free the cold wind",
            author: "George Stephenson",
            iconResourceId: "activity_edit_music_list_freethecoldwind",
            musicResourceId: "FREE_THE_COLD_WIND",
            musicSelectedResourceId: "activity_edit_music_selected_freethecoldwind"))
        
        localMusic.append(Music(title: "Galloping",
            author: "A. Stuart Roslyn",
            iconResourceId: "activity_edit_music_list_galloping",
            musicResourceId: "GALLOPING",
            musicSelectedResourceId: "activity_edit_music_selected_galloping"))

        
        localMusic.append(Music(title: "Sorrow and sandness",
            author: "David John",
            iconResourceId: "activity_edit_music_list_sorrowandsadness",
        musicResourceId: "SORROW_AND_SADNESS",
        musicSelectedResourceId: "activity_edit_music_selected_sorrowandsadness"))

        localMusic.append(Music(title: "We beat as one",
            author: "Harlin James",
            iconResourceId: "activity_edit_music_list_webeatasone",
            musicResourceId: "WE_BEAT_AS_ONE",
            musicSelectedResourceId: "activity_edit_music_selected_webeatasone"))

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
