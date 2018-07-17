//
//  RealmMigrationsUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 3/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMigrationsUseCase {

    static func updateMigrationDefault() {
        
        let newVersion = UInt64(11)
        Realm.Configuration.init()
        var config = Realm.Configuration(
            schemaVersion: newVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 11) {
                    
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
    }
}
