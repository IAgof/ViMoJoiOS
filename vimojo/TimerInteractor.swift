//
//  TimerInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class TimerInteractor: NSObject,TimerInteractorInterface {

    var time = "00:00"
    var startTime = TimeInterval()
    var timer:Timer = Timer()
    
    var delegate : TimerInteractorDelegate?
    
    func start(){
        if (!timer.isValid) {
            let aSelector : Selector = #selector(TimerInteractor.updateTime)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = Date.timeIntervalSinceReferenceDate
        }
    }
    
    func stop(){
        timer.invalidate()
        
        delegate?.updateTimer("00:00")
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        var elapsedTime: TimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        time = "\(strMinutes):\(strSeconds)"
        
        delegate?.updateTimer(time)
    }
    
    func setDelegate(_ delegate:TimerInteractorDelegate){
        self.delegate = delegate
    }
}
