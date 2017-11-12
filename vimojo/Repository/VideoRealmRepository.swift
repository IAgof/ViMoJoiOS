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

public class VideoRealmRepository: VideoRepository {
    var toRealmVideoMapper: VideoToRealmVideoMapper
    var toVideoMapper: RealmVideoToVideoMapper

    init() {
        self.toRealmVideoMapper = VideoToRealmVideoMapper()
        self.toVideoMapper = RealmVideoToVideoMapper()
    }

    public func add(item: Video) {
        do {
            let realm = try Realm()
            try realm.write {
                let realmVideo =  toRealmVideoMapper.map(from: item)
                realm.add(realmVideo)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }
    public func add(items: [Video]) {
        for video in items {
            add(item: video)
        }
    }

    public func update(item: Video) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toRealmVideoMapper.map(from: item), update: true)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func update(item: Video,
                       realmProject: RealmProject) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toRealmVideoMapper.map(from: item), update: true)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func remove(item: Video) {
        do {
            let realm = try Realm()
            try realm.write {
                let result = realm.objects(RealmVideo.self).filter("uuid ='\(item.uuid)'")
                realm.delete(result)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func remove(specification: Specification) {

    }

    public func removeAllVideos() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(RealmVideo.self))
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func query(specification: Specification) -> [Video] {
        let videos: [Video] = []

        return videos
    }

    public func getVideos() -> Results<RealmVideo> {
        //TODO: Is unused, and will make problems with the old unwrapping
        var results:Results<RealmVideo>!
        do {
            let realm = try Realm()
            try realm.write {
                results = realm.objects(RealmVideo.self)
            }
        } catch {
            print("Error writing project:\(error)")
        }
        return results
    }

    public func duplicateVideo(realmVideo: RealmVideo, completion: (RealmVideo) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                guard let videoToCopy = realm.objects(RealmVideo.self).filter("uuid ='\(realmVideo.uuid)'").last else { return }
                let newVideoRealm = RealmVideo()
                newVideoRealm.uuid = UUID().uuidString
                newVideoRealm.title = videoToCopy.title
                newVideoRealm.stopTime = videoToCopy.stopTime
                newVideoRealm.startTime = videoToCopy.startTime
                newVideoRealm.position = videoToCopy.position
                newVideoRealm.mediaPath = videoToCopy.mediaPath
                newVideoRealm.videoURL = videoToCopy.videoURL
                newVideoRealm.clipTextPosition = videoToCopy.clipTextPosition
                newVideoRealm.clipText = videoToCopy.clipText
                
                realm.add(newVideoRealm)
                completion(newVideoRealm)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }
    //TODO: make this function readabled
//    public func writeOnRealm(){
//        do {
//            let realm = try Realm()
//            try realm.write {
//
//            }
//        } catch {
//            print("Error writing project:\(error)")
//        }
//    }
}
