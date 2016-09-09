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
    func pushSpaceOnDisk()
    
    func pushConfigMode(modePushed:VideoModeConfigurations)
    
    func pushISOConfig()
    func pushWBConfig()
    
    func pushCloseBatteryButton()
    func pushCloseSpaceOnDiskButton()
    
    func resetRecorder()
    func displayHasPinched(pinchGesture:UIPinchGestureRecognizer)
    func checkFlashAvaliable()
    
    func zoomValueChanged(value:Float)
    func batteryValuesUpdate(value:Float)
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
    func showSpaceOnDisk()
    
    func getControllerName()->String
    func updateChronometer(time:String)
    
    func hidePrincipalViews()
    func showPrincipalViews()
    
    func hideSecondaryRecordViews()
    func showSecondaryRecordViews()
    
    func hideZoomView()
    func showZoomView()
    
    func setSliderValue(value:Float)
    func setBatteryIcon(image:UIImage)
    
    func updateBatteryValues()
    func hideBatteryView()
    
    func updateSpaceOnDiskValues()
    func hideSpaceOnDiskView()
    
    func showISOConfigView()
    func hideISOConfigView()
    
    func showWBConfigView()
    func hideWBConfigView()
}