//
//  AudioRealmRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import RealmSwift

public class AudioRealmRepository:AudioRepository{
    var toRealmAudioMapper:AudioToRealmAudioMapper
    var toAudioMapper:RealmAudioToAudioMapper

    init() {
        self.toRealmAudioMapper = AudioToRealmAudioMapper()
        self.toAudioMapper = RealmAudioToAudioMapper()
    }
    
    public func add(item: Audio) {
        do{
            let realm = try! Realm()
            try realm.write {
                let realmAudio =  toRealmAudioMapper.map(from: item)
                realm.add(realmAudio)
            }
        }catch{
            print("Error writing project:\(error)")
        }
    }
    public func add(items: [Audio]) {
        for audio in items{
            add(item: audio)
        }
    }
    
    public func update(item: Audio) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(toRealmAudioMapper.map(from: item), update: true)
        }
    }
    
    public func update(item: Audio,
                       realmProject: RealmProject) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(toRealmAudioMapper.map(from: item), update: true)
        }
    }
    
    public func remove(item: Audio) {
        let realm = try! Realm()
        
        try! realm.write {
            let result = realm.objects(RealmAudio.self).filter("uuid ='\(item.uuid)'")
            realm.delete(result)
        }
    }
    
    public func remove(specification: Specification) {
        
    }

    public func query(specification: Specification) -> [Audio] {
        let audios:[Audio] = []
        
        return audios
    }
}
