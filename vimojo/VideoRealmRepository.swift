//
//  VideoRealmRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import RealmSwift

public class VideoRealmRepository:VideoRepository{
    var toRealmVideoMapper:VideoToRealmVideoMapper
    var toVideoMapper:RealmVideoToVideoMapper
    
    //    protected VideoRepository videoRepository = new VideoRealmRepository();
    
    init() {
        self.toRealmVideoMapper = VideoToRealmVideoMapper()
        self.toVideoMapper = RealmVideoToVideoMapper()
    }
    
    public func add(item: Video) {
        do{
            let realm = try! Realm()
            try realm.write {
                let realmVideo =  toRealmVideoMapper.map(from: item)
                realm.add(realmVideo)
            }
        }catch{
            print("Error writing project:\(error)")
        }
    }
    public func add(items: [Video]) {
        for video in items{
            add(item: video)
        }
    }
    
    public func update(item: Video) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(toRealmVideoMapper.map(from: item), update: true)
        }
    }
    
    public func update(item: Video,
                       realmProject: RealmProject) {
        let realm = try! Realm()
       
        try! realm.write {
            realm.add(toRealmVideoMapper.map(from: item), update: true)
        }
    }
    
    public func remove(item: Video) {
        let realm = try! Realm()
        
        try! realm.write {
            let result = realm.objects(RealmVideo.self).filter("uuid ='\(item.uuid)'")
            realm.delete(result)
        }
    }
    
    public func remove(specification: Specification) {
        
    }
    
    public func removeAllVideos() {
        let realm = try! Realm()

        try! realm.write {
            realm.delete(realm.objects(RealmVideo.self))
        }
    }
    
    public func query(specification: Specification) -> [Video] {
        let videos:[Video] = []
        
        return videos
    }
    
    public func getVideos() -> Results<RealmVideo> {
        let realm = try! Realm()
        return realm.objects(RealmVideo.self)
    }
}
