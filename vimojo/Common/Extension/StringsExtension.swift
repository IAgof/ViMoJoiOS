//
//  StringsExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/5/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension String{
    enum LocalizeTable: String {
        case settings = "Settings"
        case detailProject = "DetailProject"
        case drawerMenu = "DrawerMenu"
        case editor = "EditorStrings"
        case musicDetail = "MusicDetailView"
        case musicProvider = "MusicProvider"
        case micRecorder = "MicRecorder"
        case projectList = "ProjectList"
        case share = "Share"
		case purchase = "Purchase"
        case urls = "URLs"
    }
    
    func localize(inTable table: String? = nil) -> String{
        return Bundle.main.localizedString(forKey: self, value: nil, table: table)
    }
    var localized: (LocalizeTable) -> String { 
        return { table in 
            Bundle.main.localizedString(forKey: self, value: nil, table: table.rawValue)
        }
    }
    func addColons() -> String {
        return self + ":"
    }
    func addSpace() -> String {
        return self + " "
    }
}
