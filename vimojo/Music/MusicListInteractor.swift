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

    // MARK: - VIPER Variables
    var delegate: MusicListInteractorDelegate?

    // MARK: - Variables
    var musicList: [Music] = []
    var project: Project?
    var actualComposition: VideoComposition?

    // MARK: - Interface
    func getMusicList() {
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
        if let image = UIImage(named: musicList[index].musicSelectedResourceId) {
            return image
        } else {
            return UIImage()
        }
    }

    func getMusicDetailParams(_ index: Int) {
        guard let project = project else {return}

        let music = musicList[index]
        let title = music.getMusicTitle()
        let author = music.getAuthor()
        let duration = MusicListString.MUSIC_DETAIL_DURATION.appending(Utils().formatTimeToMinutesAndSeconds(music.getDuration()))

        let mixAudio = MixAudioModel(audioVolume: music.audioLevel,
                                     videoVolume: project.projectOutputAudioLevel,
                                     mixVideoWeight: MusicListConstants.mixAudioWeight)

        var viewModel = MusicDetailViewModel(image: UIImage(), title: title, author: author, sliderValue: 1, duration:duration)

        guard let image = UIImage(named: musicList[index].musicSelectedResourceId) else {
            delegate?.setMusicDetailParams(musicDetailViewModel: viewModel)
            return
        }

        viewModel.image = image
        delegate?.setMusicDetailParams(musicDetailViewModel: viewModel)
    }

    func getMusic() {
        guard let music = project?.music else {return}

        let title = music.getMusicTitle()
        let author = music.getAuthor()
        var viewModel = MusicDetailViewModel(image: UIImage(), title: title, author: author, sliderValue: music.audioLevel, duration:"")

        guard let image = UIImage(named: music.musicSelectedResourceId) else {
            delegate?.setMusicDetailParams(musicDetailViewModel: viewModel)
            return
        }

        viewModel.image = image
        delegate?.setMusicDetailParams(musicDetailViewModel: viewModel)
    }

    func setMusicToProject(_ index: Int) {
        guard let project = project else {return}
        var music = Music(title: "",
                          author: "",
                          iconResourceId: "",
                          musicResourceId: "",
                          musicSelectedResourceId: "")
        if index == -1 {
            project.music = nil
            project.projectOutputAudioLevel = 1

        } else {
            music = musicList[index]

            project.music = music
            project.projectOutputAudioLevel = 0
        }

        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }

    func hasMusicSelectedInProject() -> Bool {
        guard let musicSet = project?.isMusicSet else {
            return false
        }
        return musicSet
    }

    func getVideoComposition() {
        if project != nil {
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project!)
            if let composition = actualComposition {
                let animatedLayer = GetActualProjectCALayerAnimationUseCase(videonaComposition: composition).getCALayerAnimation(project: project!)
                composition.layerAnimation?.addSublayer(animatedLayer)
                delegate?.setVideoComposition(composition)
            }
        }
    }

    func updateAudioMix(withParameter param: MixAudioModel) {
        guard let project = project else {return}

        project.projectOutputAudioLevel = param.videoVolume
        let music = project.music
        music?.audioLevel = param.audioVolume

        let composition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        if let audioMix = composition.audioMix {
            delegate?.setAudioMix(audioMix: audioMix)
        }
        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }

    // MARK: - Inner functions
    func getMusicViewModelList(_ list: [Music]) -> [MusicViewModel] {
        var musicViewList: [MusicViewModel] = []

        for music in list {
            guard let iconImage = UIImage(named: music.getIconResourceId()) else {return []}
            let newMusic = MusicViewModel(image: iconImage, title: music.getTitle(), author: music.getAuthor())

            musicViewList.append(newMusic)
        }

        return musicViewList
    }

    func getMusicBackgroundImageList(_ list: [Music]) -> [UIImage] {
        var imageList: [UIImage] = []

        for music in list {
            let image = UIImage(named: music.getIconResourceId())
            imageList.append(image!)
        }

        return imageList
    }
}
