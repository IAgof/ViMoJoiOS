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
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]
    var audioStringPath:String?
    
    func initAudioSession(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            audioStringPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/audio\(Utils.sharedInstance.giveMeTimeNow()).m4a")
            guard let audioURLPath = NSURL(string: audioStringPath!) else{return}
            
            try audioRecorder = AVAudioRecorder(URL: audioURLPath,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch {
        }
    }
    
    //MARK: - Interface
    func getVideoComposition() {
        if project != nil{
            actualComposition = GetActualProjectAVCompositionUseCase.sharedInstance.getComposition(project!)
            if actualComposition != nil {
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
        guard var url = NSURL(string: path) else {
            print("No audio url path" )
            return}
        
//        print("Set music in debug")
//        url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GALLOPING", ofType: "mp3")!)
//        
        delegate?.setActualAudioRecorded(url)
    }
    
    func setVoiceOverToProject(videoVolume: Float, audioVolume: Float) {
        guard let path = audioStringPath else {
            print("No audio string path" )
            return}
        
        let voiceOver = Audio(title: "Vimojo VoiceOver", mediaPath: path)
        voiceOver.audioLevel = audioVolume
        project?.projectOutputAudioLevel = videoVolume
        
        project?.isVoiceOverSet = true
        project?.voiceOver = voiceOver
    }
    
    func removeVoiceOverFromProject(){
        project?.isVoiceOverSet = false
        project?.projectOutputAudioLevel = 1.0
    }
    
    func getStringByKey(key:String) -> String {
        return NSBundle.mainBundle().localizedStringForKey(key,value: "",table: "MicRecorder")
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