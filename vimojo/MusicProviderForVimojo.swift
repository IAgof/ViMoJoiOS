//
//  MusicProviderForVimojo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

extension MusicProvider {
    func populateLocalMusic() {

        localMusic.append(Music(title: "Going higher",
                                author: getStringByKeyFromMusicProvider(key: "author_music_going_higher"),
                                iconResourceId: "activity_edit_music_list_going_higher",
                                musicResourceId: "goinghigher",
                                musicSelectedResourceId: "activity_edit_music_selected_going_higher"))

        localMusic.append(Music(title: "Ukulele",
                                author: getStringByKeyFromMusicProvider(key: "author_music_ukulele"),
                                iconResourceId: "activity_edit_music_list_ukulele",
                                musicResourceId: "ukulele",
                                musicSelectedResourceId: "activity_edit_music_selected_ukulele"))

        localMusic.append(Music(title: "Jazzy-Frenchy",
                                author: getStringByKeyFromMusicProvider(key: "author_music_jazzy_frenchy"),
                                iconResourceId: "activity_edit_music_list_jazzy_frenchy",
                                musicResourceId: "jazzyfrenchy",
                                musicSelectedResourceId: "activity_edit_music_selected_jazzy_frenchy"))

        localMusic.append(Music(title: "Acoustic Breeze",
                                author: getStringByKeyFromMusicProvider(key: "author_music_acoustic_breeze"),
                                iconResourceId: "activity_edit_music_list_acoustic_breeze",
                                musicResourceId: "acousticbreeze",
                                musicSelectedResourceId: "activity_edit_music_selected_acoustic_breeze"))

    }

    private func getStringByKeyFromMusicProvider(key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: "MusicProvider")
    }
}
