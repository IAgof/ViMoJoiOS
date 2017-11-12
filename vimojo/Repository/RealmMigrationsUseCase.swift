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
    let newSchemaVersion = UInt64(5)
    let oldSchemaVersion = UInt64(4)

    func updateMigrationDefault() {
        // Inside your application(application:didFinishLaunchingWithOptions:)

        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: newSchemaVersion,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < self.oldSchemaVersion) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        do {
            let realm = try Realm()
        } catch {
            print("RealmMigrationsUseCase Error:\(error)")
        }
    }
}
