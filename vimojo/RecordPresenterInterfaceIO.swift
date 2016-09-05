//
//  RecordPresenterInterfaceIO.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage

protocol RecordPresenterInterface{
    func viewDidLoad(displayView:GPUImageView)
    func viewWillDisappear()
    func viewWillAppear()
    
    func pushRecord()
    func pushFlash()
    func pushRotateCamera()
    
    func resetRecorder()
    func displayHasPinched(pinchGesture:UIPinchGestureRecognizer)
    func checkFlashAvaliable()
}

protocol RecordPresenterDelegate {
    func configureView()
    func forceOrientation()
    func recordButtonEnable(state:Bool)
   
    func showFlashOn(on:Bool)
    func showRecordButton()
    func showFlashSupported(state:Bool)
    func showBackCameraSelected()
    func showFrontCameraSelected()
    func showFocusAtPoint(point:CGPoint)
    func showStopButton()
    
    func getControllerName()->String
    func updateChronometer(time:String)
    
}