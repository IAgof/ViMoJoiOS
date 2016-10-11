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
import AVFoundation

struct MicRecorderViewModel{
    var lowValue:String
    var actualValue:String
    var highValue:String
    var sliderRange:Double
}

class MusicInteractor: MusicInteractorInterface {
    
    //MARK: - VIPER Variables
    var delegate:MusicInteractorDelegate?
    
    //MARK: - Variables
    var musicList:[Music] = []
    var project: Project?
    var actualComposition:AVMutableComposition?
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
        guard let composition = actualComposition else{
            return
        }
        let highValue = Utils().hourToString(composition.duration.seconds)
        let sliderRange = composition.duration.seconds
        let micValues = MicRecorderViewModel(
            lowValue: lowValue, actualValue: actualValue,highValue: highValue , sliderRange: sliderRange
        )

        delegate?.setMicRecorderValues(micValues)
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