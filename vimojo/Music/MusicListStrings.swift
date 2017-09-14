//
//  MusicListStrings.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 2/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

struct MusicListString {
    static var MUSIC_DETAIL_DURATION: String {
        return getStringByKey("music_detail_duration")
    }

    static private func getStringByKey(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: "MusicDetailView")
    }
}
