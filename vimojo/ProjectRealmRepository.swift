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

public class ProjectRealmRepository:ProjectRepository{
    var toRealmProjectMapper:ProjectToRealmProjectMapper
    var toProjectMapper:RealmProjectToProjectMapper
    
//    protected VideoRepository videoRepository = new VideoRealmRepository();

    init() {
        self.toRealmProjectMapper = ProjectToRealmProjectMapper()
        self.toProjectMapper = RealmProjectToProjectMapper()
    }
    
    public func add(item: Project) {
            let realm = try! Realm()
            try! realm.write {
                realm.add(toRealmProjectMapper.map(from: item))
            }
    }
    
    public func add(items: [Project]) {
        for project in items{
            add(item: project)
        }
    }
    public func update(item: Project) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(toRealmProjectMapper.map(from: item), update: true)
        }
    }
    
    public func remove(item: Project) {
        let realm = try! Realm()
        
        try! realm.write {
            let result = realm.objects(RealmProject.self).filter("title ='\(item.getTitle())'")
            realm.delete(result)
        }
    }
    
    public func remove(specification: Specification) {
        
    }
    
    public func query(specification: Specification) -> [Project] {
        let project = Project()
        
        return [project]
    }
    
    public func getCurrentProject()->Project{
        var project = Project()
        let realm = try! Realm()
        
        try! realm.write {
            if let result = realm.objects(RealmProject.self).last{
                project = self.toProjectMapper.map(from: result)
            }else{
                realm.add(self.toRealmProjectMapper.map(from: project))
                try! realm.commitWrite()
            }
        }
        return project
    }
}
