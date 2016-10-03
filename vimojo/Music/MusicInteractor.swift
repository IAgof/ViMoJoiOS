//
//  MusicInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject


class MusicInteractor: MusicInteractorInterface {
    
    //MARK: - VIPER Variables
    var delegate:MusicInteractorDelegate?
    
    //MARK: - Variables
    var musicList:[Music] = []
    var project: Project?
    
    //MARK: - Interface
    func getMusicList(){
        musicList = MusicProvider.sharedInstance.retrieveLocalMusic()
        
        delegate?.setMusicModelList(getMusicViewModelList(musicList))
    }
    
    func getTitleFromIndexPath(index: Int) -> String {
        
        return musicList[index].getMusicTitle()
    }
    
    func getAuthorFromIndexPath(index: Int) -> String {
        return musicList[index].getAuthor()

    }
    
    func getImageFromIndexPath(index: Int) -> UIImage {
        if let image = UIImage(named: musicList[index].musicSelectedResourceId){
            return image
        }else{
            return UIImage()
        }
    }
    
    func setMusicToProject(index: Int) {
        var music = Music(title: "",
                          author: "",
                          iconResourceId: "",
                          musicResourceId: "",
                          musicSelectedResourceId: "")
        if index == -1 {
            project?.setMusic(music)
            project?.isMusicSet = false
            
        }else{
            music = musicList[index]
            
            project?.setMusic(music)
            project?.isMusicSet = true
        }
    }
    
    func hasMusicSelectedInProject()->Bool{
        guard let musicSet = project?.isMusicSet else{
            return false
        }
        return musicSet
    }
    
    func getMusic() -> Music {
        guard let music = project?.getMusic() else {return  Music(title: "",
                                                                  author: "",
                                                                  iconResourceId: "",
                                                                  musicResourceId: "",
                                                                  musicSelectedResourceId: "")
        }
        return music
    }
    
    func getProject()->Project{
        return project!
    }
    
    //MARK: - Inner functions
    func getMusicViewModelList(list:[Music]) -> [MusicViewModel] {
        var musicViewList:[MusicViewModel] = []

        for music in list{
            guard let iconImage = UIImage(named: music.getIconResourceId()) else{return []}
            let newMusic = MusicViewModel(image: iconImage, title: music.getTitle(), author: music.getAuthor())

            musicViewList.append(newMusic)
        }
        
        return musicViewList
    }
    
    func getMusicBackgroundImageList(list:[Music]) -> [UIImage] {
        var imageList:[UIImage] = []
        
        for music in list{
            let image = UIImage(named: music.getIconResourceId())
            imageList.append(image!)
        }
        
        return imageList
    }
}