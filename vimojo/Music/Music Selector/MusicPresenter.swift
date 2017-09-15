//
//  MusicPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation
import VideonaProject
import Photos

class MusicPresenter: MusicPresenterInterface, MusicInteractorDelegate {
    // MARK: - Variables VIPER
    var delegate: MusicPresenterDelegate?
    var interactor: MusicInteractorInterface?
    var wireframe: MusicWireframe?

    var detailEventHandler: MusicDetailInterface?

    var playerPresenter: PlayerPresenterInterface?
    var playerWireframe: PlayerWireframe?

    // MARK: - Variables
    var lastMusicSelected: Int = -1
    var isMusicSet: Bool = false
    var isGoingToExpandPlayer = false
    var recordMicViewActualTime = 0.0
    var recordMicViewTotalTime = 0.0

    var projectAudios: MusicSelectorCellViewModel? {
        if let project = interactor?.project {
            let projectAudios = project.getVideoList()
            var totalTime: Double = 0
            let items = projectAudios.map({ (video) -> SelectorItem in
                let item = SelectorItem(with: video.thumbnailImage,
                                        timeRange: CMTimeRange(start: video.getStartTime() + totalTime, end: video.getStopTime() + totalTime),
                                        action: {
                                            self.wireframe?.presentVideoAudio(video: video)
                })
                totalTime += video.getStopTime()
                return item
            })

            return MusicSelectorCellViewModel(with: .originalAudio,
                                              items: items, audioVolume: project.projectOutputAudioLevel)
        } else { return nil }
    }

    var musicAudio: MusicSelectorCellViewModel? {
        if let music = interactor?.project?.music {
            return MusicSelectorCellViewModel(with: .music,
                                              items: [SelectorItem(with: UIImage(named: music.getIconResourceId()),
                                                                   timeRange: CMTimeRange(start: music.getStartTime(), end: music.getStopTime()),
                                                                   action: {
                                                                    print("Audios audio Has been tapped")
                                                                    self.wireframe?.presenterMusicListView()
                                              })], audioVolume: music.audioLevel)
        } else {return nil}
    }

    var micAudio: MusicSelectorCellViewModel? {
        if let micAudios = interactor?.project?.voiceOver, !micAudios.isEmpty {
            return MusicSelectorCellViewModel(with: .voiceOver,
                                              items: micAudios.map({ SelectorItem(with: #imageLiteral(resourceName: "activity_image_adjust_filter_normal"),
                                                                                  timeRange: CMTimeRange(start: $0.getStartTime(), end: $0.getStopTime()),
                                                                                  action: {
                                                                                    print("Mic audio Has been tapped")
                                                                                    self.wireframe?.presenterMicRecorderView()
                                              })}), audioVolume: micAudios.first!.audioLevel)
        } else { return nil}
    }

    // MARK: - Constants
    let NO_MUSIC_SELECTED = -1

    // MARK: - Interface
    func viewDidLoad() {
        self.addFloatingButtons()
    }

    private func addFloatingButtons() {
        var floatingItems: [FloatingItem] = []
        floatingItems.append(FloatingItem(item: FloatingItemFactory.music, action: {
            self.wireframe?.presenterMusicListView()
        }))

        floatingItems.append(FloatingItem(item: FloatingItemFactory.mic, action: {
            self.wireframe?.presenterMicRecorderView()
        }))

        delegate?.floatingItems = floatingItems
    }

    func viewWillAppear() {
        wireframe?.presentPlayerInterface()

        delegate?.bringToFrontExpandPlayerButton()
        interactor?.getVideoComposition()

        setAudios()
    }

    func setAudios() {
        var audiosViewModel: [MusicSelectorCellViewModel] = []

        if let videoAudios = projectAudios { audiosViewModel.append(videoAudios)}
        if let musicAudios = musicAudio { audiosViewModel.append(musicAudios) }
        if let micAudios = micAudio { audiosViewModel.append(micAudios)}

        delegate?.audios = audiosViewModel
    }

    func viewDidAppear() {

    }

    func viewWillDisappear() {
        if !isGoingToExpandPlayer {
            playerPresenter?.onVideoStops()
        }
    }

    func expandPlayer() {
        wireframe?.presentExpandPlayer()

        isGoingToExpandPlayer = true
    }

    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }

    func pushMusicHandler() {
        wireframe?.presenterMusicListView()
    }

    func pushMicHandler() {
        wireframe?.presenterMicRecorderView()
    }

    func pushOptions() {
        wireframe?.presentSettings()
    }

    // MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }

    func update(audioMix: AVAudioMix) {
        playerPresenter?.setAudioMix(audioMix: audioMix)
    }
}
