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
    func pushHideAllButtons()
    func pushZoom()
    func pushBattery()
    func pushCloseBatteryButton()
    
    func resetRecorder()
    func displayHasPinched(pinchGesture:UIPinchGestureRecognizer)
    func checkFlashAvaliable()
    
    func zoomValueChanged(value:Float)
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
    func showHideAllButtonsButtonImage()
    func showAllButtonsButtonImage()
    func showBatteryRemaining()
    
    func getControllerName()->String
    func updateChronometer(time:String)
    
    func hidePrincipalViews()
    func showPrincipalViews()
    
    func hideSecondaryRecordViews()
    func showSecondaryRecordViews()
    
    func hideZoomView()
    func showZoomView()
    
    func setSliderValue(value:Float)
    
    func updateBatteryValues()
    func hideBatteryView()
}