//
//  MicRecorderPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation
import VideonaProject

class MicRecorderPresenter: MicRecorderPresenterInterface {
    // MARK: - Variables VIPER
    var delegate: MicRecorderPresenterDelegate?
    var interactor: MicRecorderInteractorInterface?
    var wireframe: MicRecorderWireframe?

    var detailEventHandler: MusicDetailInterface?

    var playerPresenter: PlayerPresenterInterface?

    // MARK: - Variables
    var isMusicSet: Bool = false
    var isGoingToExpandPlayer = false
    var isPlayingMedia = false
    var isRecording = false
    var recordMicViewActualTime: Float = 0.0
    var recordMicViewTotalTime = 0.0
    var videoVolume: Float = 1.0
    var audioVolume: Float = 1.0
    var lastMusicSelected: Int = -1
    var videoTotalTime: Double = 0

    var micRecordedTimeRangeValues: [CMTimeRange] = [] {
        didSet {
            if micRecordedTimeRangeValues.count == 0 {
                delegate?.hideHasRecordViews()
            } else {
                delegate?.showHasRecordViews()
            }
        }
    }
	
	open func viewDidLayoutSubviews(_ value: CGFloat) {
		DispatchQueue.main.async(execute: {
			self.delegate?.updateMicRecorderRangeSliderDiameter(value)
		})
	}

    var trackOverSliderNumber = -1 {
        didSet {
            if trackOverSliderNumber != NO_TRACK_SELECTED {
                delegate?.recordButtonIsHidden(isHidden: true)
                delegate?.deleteVoiceOverTrackButtonIsHidden(isHidden: false)

                if isRecording {
                    pauseRecord()
                }
            } else {
                delegate?.recordButtonIsHidden(isHidden: false)
                delegate?.deleteVoiceOverTrackButtonIsHidden(isHidden: true)
            }
        }
    }

    let checkTrackOverQueue = DispatchQueue(label: "checkTrackOverQueue")

    // MARK: - Constants
    let NO_MUSIC_SELECTED = -1
    let NO_TRACK_SELECTED = -1

    // MARK: - Interface
    func viewDidLoad() {
        wireframe?.presentPlayerInterface()

        interactor?.getVideoComposition()
        interactor?.getMicRecorderValues()
        interactor?.getActualAudioRecorded()
    }

    func viewWillAppear() {
        interactor?.loadVoiceOverAudios()
        playerPresenter?.removeFinishObserver()
    }

    func viewDidAppear() {

    }

    func viewWillDisappear() {
        resetRecord()
    }

    func playerHasLoaded() {

    }

    func pushBackButton() {
        playerPresenter?.setPlayerMuted(false)

        playerPresenter?.pauseVideo()
        delegate?.pauseAudioPlayer()

        delegate?.removeAudioPlayer()

        if !isGoingToExpandPlayer {
            playerPresenter?.onVideoStops()
        }
        wireframe?.removeController()
    }

    func acceptPushed() {
        interactor?.setVoiceOverToProject(videoVolume, audioVolume: audioVolume)
        resetAudioParams()
        ViMoJoTracker.sharedInstance.trackVoiceOverAdded()

		wireframe?.removeController()
    }

    func cancelPushed() {
        if micRecordedTimeRangeValues.isEmpty {
            pushBackButton()
            return
        }

        guard let title = interactor?.getStringByKey(MicRecorderConstants.DISCARD_RECORDER_TITLE) else {return}
        guard let message = interactor?.getStringByKey(MicRecorderConstants.DISCARD_RECORDER_MESSAGE)else {return}
        guard let yes = interactor?.getStringByKey(MicRecorderConstants.YES_ACTION)
            else {return}

        delegate?.showAlertDiscardRecord(title,
                                         message: message,
                                         yesString: yes)
    }

    func cancelConfirmed() {
        resetRecord()
        resetAudioParams()

        interactor?.removeVoiceOverFromProject()

        interactor?.getMicRecorderValues()
    }

    func removeVoiceOverTrack() {
        if trackOverSliderNumber != NO_TRACK_SELECTED {
            micRecordedTimeRangeValues.remove(at: trackOverSliderNumber)
            interactor?.removeVoiceOverTrack(inPosition: trackOverSliderNumber)
            delegate?.removeTrackArea(inPosition: trackOverSliderNumber)
            trackOverSliderNumber = NO_TRACK_SELECTED
        }
    }

    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }

    func getMicRecorderViewValues() {
        interactor?.getMicRecorderValues()
    }

    func startLongPress(atTime: CMTime) {
        startRecord(atTime: atTime)

        playerPresenter?.setPlayerMuted(true)
        isRecording = true
    }

    func pauseLongPress() {
        pauseRecord()
    }

    func startRecord(atTime: CMTime) {
        delegate?.setMicRecorderButtonState(true)

        if !isPlayingMedia {
            playerPresenter?.pushPlayButton()
        }

        interactor?.startRecordMic(atTime: atTime,
                                   audioVolume: audioVolume)

        delegate?.showHasRecordViews()
    }

    func pauseRecord() {

        playerPresenter?.setPlayerMuted(false)
        isRecording = false

        delegate?.setMicRecorderButtonState(false)
        playerPresenter?.pushPlayButton()

        interactor?.stopRecordMic()
        interactor?.getActualAudioRecorded()
    }

    func resetRecord() {

        playerPresenter?.pauseVideo()
        playerPresenter?.setPlayerVolume(1)

        delegate?.pauseAudioPlayer()

        bothPlayersSeeks(toTime:0.0)

        trackOverSliderNumber = NO_TRACK_SELECTED

        delegate?.hideHasRecordViews()
        delegate?.setMicRecorderButtonState(false)
        delegate?.setMicRecorderButtonEnabled(true)

        for i in (0...(micRecordedTimeRangeValues.count)).reversed() {
            delegate?.removeTrackArea(inPosition: i)
        }

        micRecordedTimeRangeValues = []
    }

    func updateActualTime(_ time: Float) {
        checkIfThisTimeBeenInAnyRecordedRange(time: time)
        recordMicViewActualTime = time

        if isRecording {
            if time >= Float(recordMicViewTotalTime - 0.1) {
                pauseRecord()
            }

            DispatchQueue.main.async {
                self.updateLastAudioTrackAreaWithValue(time: time)
            }
        }
    }

    func updateLastAudioTrackAreaWithValue(time: Float) {
        if let micRecordedValue = micRecordedTimeRangeValues.last {

            let position = micRecordedTimeRangeValues.count - 1

            let maxTime = Float(videoTotalTime)
            let lowerValue = Float(micRecordedValue.start.seconds)

            micRecordedTimeRangeValues[micRecordedTimeRangeValues.count - 1] = CMTimeRangeMake(micRecordedValue.start,
                                                   CMTimeMakeWithSeconds(Float64(time - lowerValue), 600))

            let trackModel = TrackModel(maxValue: maxTime,
                                        lowerValue: lowerValue,
                                        upperValue: time,
                                        color: configuration.mainColor.cgColor)
            debugPrint(trackModel)

            delegate?.updateRecordedTrackArea(position: position,
                                  value: trackModel)
        }
    }

    func hourToString(_ time: Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))

        return String(format:"%02d:%02d", mins, secs)
    }

    func resetAudioParams() {
        videoVolume = 1
        audioVolume = 1
    }

    func videoPlayerPlay() {
        isPlayingMedia = true

        delegate?.playAudioPlayer()
    }

    func videoPlayerPause() {
        isPlayingMedia = false

        delegate?.pauseAudioPlayer()
    }

    func videoPlayerSeeksTo(_ value: Float) {
        delegate?.seekAudioPlayerTo(value)

        if isPlayingMedia {
            delegate?.playAudioPlayer()
        }
    }

    func micInserctionPointValue(value: Float) {
        bothPlayersSeeks(toTime:value)
    }

    func bothPlayersSeeks(toTime: Float) {
        playerPresenter?.seekToTime(toTime)
        delegate?.seekAudioPlayerTo(toTime)

        checkIfThisTimeBeenInAnyRecordedRange(time: toTime)
    }

    func checkIfThisTimeBeenInAnyRecordedRange(time: Float) {
        var isOcupated = false
        var totalRanges = self.micRecordedTimeRangeValues.count

        for range in self.micRecordedTimeRangeValues {
            isOcupated = CMTimeRangeContainsTime(range, CMTimeMakeWithSeconds(Float64(time), 600))

            totalRanges -= 1
            if isOcupated {
                self.trackOverSliderNumber = self.micRecordedTimeRangeValues.count - totalRanges - 1
                return
            } else {
                self.trackOverSliderNumber = self.NO_TRACK_SELECTED
            }
        }

        if micRecordedTimeRangeValues.isEmpty {
            self.trackOverSliderNumber = self.NO_TRACK_SELECTED
        }
    }

    func deleteTrack() {
        if trackOverSliderNumber != NO_TRACK_SELECTED {
            interactor?.removeVoiceOverTrack(inPosition: trackOverSliderNumber)
            delegate?.removeTrackArea(inPosition: trackOverSliderNumber)
        }
    }
}

extension MicRecorderPresenter:MicRecorderInteractorDelegate {
    // MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        if let duration = composition.mutableComposition?.duration.seconds {
            videoTotalTime = duration
        }
        playerPresenter?.createVideoPlayer(composition)
    }

    func setMicRecorderValues(_ value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange

        delegate?.setUpValues(value)
    }

    func setActualAudioRecorded(_ voiceOverComposition: AVMutableComposition) {
        delegate?.createAudioPlayer(voiceOverComposition)
        delegate?.seekAudioPlayerTo(recordMicViewActualTime)
    }

    func setMicRecordedTimeRangeValue(micRecordedRange: CMTimeRange) {
        self.micRecordedTimeRangeValues.append(micRecordedRange)

        let trackModel = TrackModel(maxValue: Float(videoTotalTime),
                                    lowerValue: Float(micRecordedRange.start.seconds),
                                    upperValue: Float(micRecordedRange.end.seconds),
                                    color: configuration.mainColor.cgColor)
        debugPrint(trackModel)
        delegate?.setRecordedTrackArea(value: trackModel)
    }
}
