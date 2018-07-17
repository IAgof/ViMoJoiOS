//
//  ProjectRealmRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import RealmSwift

public class ProjectRealmRepository: ProjectRepository {
    var toRealmProjectMapper: ProjectToRealmProjectMapper
    var toProjectMapper: RealmProjectToProjectMapper
    let serialQueue = DispatchQueue(label: "duplicateQueue")

//    protected VideoRepository videoRepository = new VideoRealmRepository();

    init() {
        self.toRealmProjectMapper = ProjectToRealmProjectMapper()
        self.toProjectMapper = RealmProjectToProjectMapper()
    }

    public func add(item: Project) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toRealmProjectMapper.map(from: item))
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func add(items: [Project]) {
        for project in items {
            add(item: project)
        }
    }
    public func update(item: Project) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(toRealmProjectMapper.map(from: item), update: true)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func remove(item: Project) {
        do {
            let realm = try Realm()
            try realm.write {
                let result = realm.objects(RealmProject.self).filter("uuid ='\(item.uuid)'")
                realm.delete(result)
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    public func remove(specification: Specification) {

    }

    public func query(specification: Specification) -> [Project] {
        let project = Project()

        return [project]
    }

    public func getCurrentProject() -> Project {
        var project = Project()
        // TODO: This logic should be out getCurrentProject only be checked when creating New Project
//        if !configuration.IS_WATERMARK_SWITCHABLE && !configuration.IS_WATERMARK_PURCHABLE {
//            project.hasWatermark = configuration.IS_WATERMARK_ENABLED
//        }
        do {
            let realm = try Realm()
            try realm.write {
                if let result = realm.objects(RealmProject.self).sorted(byKeyPath: "modificationDate", ascending: false).first {
                    project = self.toProjectMapper.map(from: result)
                } else {
                    realm.add(self.toRealmProjectMapper.map(from: project))
                    try realm.commitWrite()
                }
            }
        } catch {
            print("Error writing project:\(error)")
        }
        return project
    }

    public func getProjectByUUID(uuid: String) -> Project? {
        var project: Project?
        do {
            let realm = try Realm()
            try realm.write {
                if let result = realm.objects(RealmProject.self).filter("uuid ='\(uuid)'").last {
                    project = self.toProjectMapper.map(from: result)
                }
            }
        } catch {
            print("Error writing project:\(error)")
        }
        return project
    }

    public func duplicateProject(id: String) {
        var projectToCopy: RealmProject? = nil
        do {
            let realm = try Realm()
            try realm.write {
                projectToCopy = realm.objects(RealmProject.self).filter("uuid ='\(id)'").last
                if projectToCopy != nil {
                    duplicateVideos(videos: projectToCopy!.videos, completion: {
                        duplicateVideoList in
                        
                        let copyText = "Copy"
                        
                        let newProjectRealm = RealmProject()
                        newProjectRealm.frameRate = projectToCopy!.frameRate
                        newProjectRealm.musicTitle = projectToCopy!.musicTitle
                        newProjectRealm.musicVolume = projectToCopy!.musicVolume
                        newProjectRealm.projectPath = projectToCopy!.projectPath
                        newProjectRealm.quality = projectToCopy!.quality
                        newProjectRealm.resolution = projectToCopy!.resolution
                        newProjectRealm.videos = duplicateVideoList
                        newProjectRealm.uuid = UUID().uuidString
                        newProjectRealm.exportedDate = projectToCopy?.exportedDate
                        newProjectRealm.exportedPath = projectToCopy?.exportedPath
                        newProjectRealm.modificationDate = projectToCopy?.modificationDate
                        
                        if let title = projectToCopy?.title {
                            newProjectRealm.title = copyText.appending(title)
                        } else {
                            newProjectRealm.title = "Copy project"
                        }
                        
                        realm.add(newProjectRealm)
                    })
                }
            }
        } catch {
            print("Error writing project:\(error)")
        }
    }

    func duplicateVideos(videos: List<RealmVideo>, completion:@escaping (List<RealmVideo>) -> Void) {
        let newVideoList: List<RealmVideo> = List<RealmVideo>()

        var count = 0
        for video in videos {
            serialQueue.sync {
                VideoRealmRepository().duplicateVideo(realmVideo: video, completion: {
                    duplicateVideo in
                    newVideoList.append(duplicateVideo)

                    count += 1
                    if count == videos.count {
                        completion(newVideoList)
                    }
                })
            }
        }

    }

    public func getAllProjects() -> [Project] {
        var projects: [Project] = []
        do {
            let realm = try Realm()
            try realm.write {
                let results = realm.objects(RealmProject.self).sorted(byKeyPath: "modificationDate", ascending: false)
                projects = results.map({ self.toProjectMapper.map(from: $0) })
            }
        } catch {
            print("Error writing project:\(error)")
        }
        return projects
    }
}
