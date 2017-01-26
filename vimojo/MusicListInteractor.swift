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
    var actualComposition:VideoComposition?
    
    //MARK: - Interface
    func getMusicList(){
        musicList = MusicProvider.sharedInstance.retrieveLocalMusic()
        
        delegate?.setMusicModelList(getMusicViewModelList(musicList))
    }
    
    func getTitleFromIndexPath(_ index: Int) -> String {
        
        return musicList[index].getMusicTitle()
    }
    
    func getAuthorFromIndexPath(_ index: Int) -> String {
        return musicList[index].getAuthor()
        
    }
    
    func getImageFromIndexPath(_ index: Int) -> UIImage {
        if let image = UIImage(named: musicList[index].musicSelectedResourceId){
            return image
        }else{
            return UIImage()
        }
    }
    
    func getMusicDetailParams(_ index:Int) {
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
    
    func setMusicToProject(_ index: Int) {
        guard let project = project else{return}
        var music = Music(title: "",
                          author: "",
                          iconResourceId: "",
                          musicResourceId: "",
                          musicSelectedResourceId: "")
        if index == -1 {
            project.setMusic(music)
            project.isMusicSet = false
            project.projectOutputAudioLevel = 1
            
        }else{
            music = musicList[index]
            
            project.setMusic(music)
            project.isMusicSet = true
            project.projectOutputAudioLevel = 0
        }
        
        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }
    
    func hasMusicSelectedInProject()->Bool{
        guard let musicSet = project?.isMusicSet else{
            return false
        }
        return musicSet
    }
    
    func getVideoComposition() {
        if project != nil{
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project!)
            if actualComposition != nil {
                let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project: project!)
                actualComposition?.layerAnimation = layer
                delegate?.setVideoComposition(actualComposition!)
            }
        }
    }
    
    func updateAudioMix(withParameter param: MixAudioModel) {
        guard let project = project else{return}
        
        project.projectOutputAudioLevel = param.videoVolume
        let music = project.getMusic()
        music.audioLevel = param.audioVolume
        
        let composition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        if let audioMix = composition.audioMix{
            delegate?.setAudioMix(audioMix: audioMix)
        }
        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }
    
    //MARK: - Inner functions
    func getMusicViewModelList(_ list:[Music]) -> [MusicViewModel] {
        var musicViewList:[MusicViewModel] = []
        
        for music in list{
            guard let iconImage = UIImage(named: music.getIconResourceId()) else{return []}
            let newMusic = MusicViewModel(image: iconImage, title: music.getTitle(), author: music.getAuthor())
            
            musicViewList.append(newMusic)
        }
        
        return musicViewList
    }
    
    func getMusicBackgroundImageList(_ list:[Music]) -> [UIImage] {
        var imageList:[UIImage] = []
        
        for music in list{
            let image = UIImage(named: music.getIconResourceId())
            imageList.append(image!)
        }
        
        return imageList
    }
}
