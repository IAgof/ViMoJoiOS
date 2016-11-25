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
        do{
            let realm = try! Realm()
            try realm.write {
                realm.add(toRealmProjectMapper.map(from: item))
            }
        }catch{
            print("Error writing project:\(error)")
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
        var project = Project()
        
        return [project]
    }
    
    public func getCurrentProject() -> Project {
        var project = Project()
        
        return project
    }
}
