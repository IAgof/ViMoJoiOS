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

struct MicRecorderViewModel{
    var lowValue:String
    var actualValue:String
    var highValue:String
    var sliderRange:Double
}

class MicRecorderInteractor :MicRecorderInteractorInterface{
    
    //MARK: - VIPER Variables
    var delegate:MicRecorderInteractorDelegate?
    
    //MARK: - Variables
    var musicList:[Music] = []
    var project: Project?
    var actualComposition:VideoComposition?
    var audioRecorder:AVAudioRecorder!
    
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                          AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.high.rawValue) as Int32)]
    var audioStringPath:String?
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
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
        if project != nil{
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project!)
            if actualComposition != nil {
                let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project: project!)
                actualComposition?.layerAnimation = layer

                delegate?.setVideoComposition(actualComposition!)
            }
        }
    }
    
    func getMicRecorderValues() {
        let lowValue = "00:00"
        let actualValue = "00:00"
        guard let composition = actualComposition?.mutableComposition else{
            return
        }
        let highValue = Utils().hourToString(composition.duration.seconds)
        let sliderRange = composition.duration.seconds
        let micValues = MicRecorderViewModel(
            lowValue: lowValue, actualValue: actualValue,highValue: highValue , sliderRange: sliderRange
        )
        
        delegate?.setMicRecorderValues(micValues)
    }
    
    func getActualAudioRecorded() {
        guard let path = audioStringPath else {
            print("No audio string path" )
            return}
        guard let url = URL(string: path) else {
            print("No audio url path" )
            return}
        
//        print("Set music in debug")
//        url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GALLOPING", ofType: "mp3")!)
//        
        delegate?.setActualAudioRecorded(url)
    }
    
    func setVoiceOverToProject(_ videoVolume: Float, audioVolume: Float) {
        guard let project = self.project else{return}

        guard let path = audioStringPath else {
            print("No audio string path" )
            return
        }
        
        let voiceOver = Audio(title: "Vimojo VoiceOver", mediaPath: path)
        voiceOver.audioLevel = audioVolume
        project.projectOutputAudioLevel = videoVolume
        
        project.isVoiceOverSet = true
        project.voiceOver = voiceOver
        
        project.updateModificationDate()
        ProjectRealmRepository().update(item: project)
    }
    
    func removeVoiceOverFromProject(){
        project?.isVoiceOverSet = false
        project?.projectOutputAudioLevel = 1.0
    }
    
    func getStringByKey(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "MicRecorder")
    }
    
    //MARK: - Mic actions
    func startRecordMic() {
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
    }
}
