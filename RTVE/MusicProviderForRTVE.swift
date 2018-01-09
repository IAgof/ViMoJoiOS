//
//  MusicProviderForRTVE.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

extension MusicProvider {
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
    }
}
