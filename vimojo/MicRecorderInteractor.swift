//
//  MicRecorderInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation
import VideonaTrackOverView

class MicRecorderInteractor :MicRecorderInteractorInterface{
    
    //MARK: - VIPER Variables
    var delegate:MicRecorderInteractorDelegate?
    
    //MARK: - Variables
    var musicList:[Music] = []
    var project: Project?
    var actualComposition:VideoComposition?
    var audioRecorder:AVAudioRecorder!
    var voiceOverAudios:[Audio] = []
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                          AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.high.rawValue) as Int32)]
    var audioStringPath:String?
    
    func loadVoiceOverAudios() {
        guard let project = self.project else{return}

        self.voiceOverAudios = project.voiceOver
        sentRecordedTimeRanges()
    }
    
    func sentRecordedTimeRanges(){
        for audio in voiceOverAudios{
            let timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(audio.getStartTime(), 600),
                                            CMTimeMakeWithSeconds(audio.getDuration(), 600))
            delegate?.setMicRecordedTimeRangeValue(micRecordedRange: timeRange)
        }
    }
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setInputGain(1)
            
            audioStringPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/audio\(Utils().giveMeTimeNow()).m4a"
            guard let audioURLPath = URL(string: audioStringPath!) else{return}
            
            try audioRecorder = AVAudioRecorder(url: audioURLPath,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
    }
    
    //MARK: - Interface
    func getVideoComposition() {
        guard let copyProject = project?.copy() as? Project else{
            return
        }
        copyProject.voiceOver = []
        copyProject.projectOutputAudioLevel = 1
        
        actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: copyProject)
        if actualComposition != nil {
            let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project: copyProject)
            actualComposition?.layerAnimation = layer
            
            delegate?.setVideoComposition(actualComposition!)
        }
    }
    
    func getMicRecorderValues() {
        let lowValue = "00:00"
        let actualValue = "00:00"
        guard let composition = actualComposition?.mutableComposition else{
            return
        }
        guard let project = self.project else{return}

        var audioVolume:Float = 0.5
        
        if !voiceOverAudios.isEmpty{
            if let volume = voiceOverAudios.first?.audioLevel{
                audioVolume = volume
            }
        }
        
        let highValue = Utils().hourToString(composition.duration.seconds)
        let sliderRange = composition.duration.seconds
        let micValues = MicRecorderViewModel(
            lowValue: lowValue, actualValue: actualValue,
            highValue: highValue , sliderRange: sliderRange,
            audioVolume: audioVolume,
            projectAudioVolume: project.projectOutputAudioLevel,
            mixAudioSliderValue: 0.5
        )
        
        delegate?.setMicRecorderValues(micValues)
    }
    
    func getActualAudioRecorded() {
        GetVoiceOverComposition().getComposition(audios: voiceOverAudios, completion: {
            voiceOverComposition in
            delegate?.setActualAudioRecorded(voiceOverComposition)
        })
    }
    
    func setVoiceOverToProject(_ videoVolume: Float, audioVolume: Float) {
        guard let project = self.project else{return}

        self.setVoiceOverAudioLevel(audioVolume: audioVolume)
        project.projectOutputAudioLevel = videoVolume
        
        project.voiceOver = voiceOverAudios
        
        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }
    
    func setVoiceOverAudioLevel(audioVolume: Float){
        for audio in voiceOverAudios{
            audio.audioLevel = audioVolume
        }
    }

    func removeVoiceOverFromProject(){
        guard let project = self.project else{return}
        project.voiceOver.removeAll()
        voiceOverAudios.removeAll()
        project.projectOutputAudioLevel = 1.0
       
        ProjectRealmRepository().update(item: project)
    }
    
    func removeVoiceOverTrack(inPosition: Int) {
        voiceOverAudios.remove(at: inPosition)
        self.getActualAudioRecorded()
    }
    
    func getStringByKey(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "MicRecorder")
    }
    
    //MARK: - Mic actions
    func startRecordMic(atTime: CMTime,audioVolume:Float) {
        initAudioSession()
        guard let audioPath = audioStringPath else{return}
        
        let audio = Audio(title: "", mediaPath: audioPath)
        audio.setStartTime(atTime.seconds)
        audio.audioLevel = audioVolume
        
        voiceOverAudios.append(audio)
        delegate?.setMicRecordedTimeRangeValue(micRecordedRange: CMTimeRangeMake(CMTimeMakeWithSeconds(audio.getStartTime(), 600),
                                                                                 CMTimeMakeWithSeconds(audio.getDuration(), 600)))

        let audioSession = AVAudioSession.sharedInstance()
        do {
            print("Start record")
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    func pauseRecordMic() {
        print("Pause record")
        audioRecorder.pause()
    }
    
    func stopRecordMic() {
        print("Stop record")

        audioRecorder.stop()
        updateLastAudioParameters()
    }
    
    func updateLastAudioParameters(){
        if let audio = voiceOverAudios.last{
            let url =  URL(fileURLWithPath: audio.getMediaPath())
            let asset = AVAsset(url: url)
            let stopTime = asset.duration.seconds + audio.getStartTime()
            
            audio.setStopTime(stopTime)            
        }
    }
}
