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
        
        let newVersion = UInt64(7)
        let oldVersion = UInt64(6)

        let config = Realm.Configuration(
            schemaVersion: newVersion,
            migrationBlock: { _, oldSchemaVersion in
                if (oldSchemaVersion < oldVersion) {
                    print("-------------------------------------------")
                    print("----------UPDATED SCHEME REALM-------------")
                    print("-------------------------------------------")
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
