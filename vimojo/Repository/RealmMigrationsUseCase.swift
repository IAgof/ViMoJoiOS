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
    let newSchemaVersion = UInt64(6)
    let oldSchemaVersion = UInt64(5)

    func updateMigrationDefault() {
        // Inside your application(application:didFinishLaunchingWithOptions:)

        let config = Realm.Configuration(
            schemaVersion: newSchemaVersion,
            migrationBlock: { _, oldSchemaVersion in
                if (oldSchemaVersion < self.oldSchemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        do {
			try Realm()
        } catch {
            print("RealmMigrationsUseCase Error:\(error)")
        }
    }
}
