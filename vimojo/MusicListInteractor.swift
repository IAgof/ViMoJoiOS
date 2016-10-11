//
//  MusicListInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class MusicListInteractor: MusicListInteractorInterface {
    
    //MARK: - VIPER Variables
    var delegate:MusicListInteractorDelegate?
    
    //MARK: - Variables
    var musicList:[Music] = []
    var project: Project?
    var actualComposition:AVMutableComposition?
    
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
    
    func getMusicDetailParams(index:Int) {
        let title = musicList[index].getMusicTitle()
        let author = musicList[index].getAuthor()
        
        guard let image = UIImage(named: musicList[index].musicSelectedResourceId) else{
            delegate?.setMusicDetailParams(title, author: author, image: UIImage())
            return
        }
        delegate?.setMusicDetailParams(title, author: author, image: image)
        
    }
    
    func getMusic(){
        guard let music = project?.getMusic() else {return}
        
        let title = music.getMusicTitle()
        let author = music.getAuthor()
        
        guard let image = UIImage(named: music.musicSelectedResourceId) else{
            delegate?.setMusicDetailParams(title, author: author, image: UIImage())
            return
        }
        delegate?.setMusicDetailParams(title, author: author, image: image)
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
    
    func getVideoComposition() {
        if project != nil{
            actualComposition = GetActualProjectAVCompositionUseCase.sharedInstance.getComposition(project!)
            if actualComposition != nil {
                delegate?.setVideoComposition(actualComposition!)
            }
        }
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