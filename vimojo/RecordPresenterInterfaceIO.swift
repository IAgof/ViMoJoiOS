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
    func pushVideoSettingsConfig()
    
    func pushHideAllButtons()
    
    func pushZoom()
    func pushBattery()
    func pushSpaceOnDisk()
    func pushMic()
    func pushFocus()
    func pushExposureModes()
    
    func pushConfigMode(modePushed:VideoModeConfigurations)
    
    func pushCloseBatteryButton()
    func pushCloseSpaceOnDiskButton()
    
    func resetRecorder()
    func checkFlashAvaliable()
    
    func batteryValuesUpdate(value:Float)
    func audioLevelHasChanged(value:Float)
}

protocol RecordPresenterDelegate {
    func configureView()
    func forceOrientation()
    func recordButtonEnable(state:Bool)
    func configModesButtonSelected(state:Bool)
   
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
    
    func showVideoSettingsConfig()
    func hideVideoSettingsConfig()
    
    func hideZoomView()
    func showZoomView()
    
    func setBatteryIcon(image:UIImage)
    func setAudioColor(color:UIColor)
    
    func updateBatteryValues()
    func hideBatteryView()
    
    func updateSpaceOnDiskValues()
    func hideSpaceOnDiskView()
    
    func showISOConfigView()
    func hideISOConfigView()
    
    func showWBConfigView()
    func hideWBConfigView()
    
    func showExposureConfigView()
    func hideExposureConfigView()
    
    func getMicValues()
    func showMicLevelView()
    func hideMicLevelView()
    func setSelectedMicButton(state:Bool)
    
    func showFocusView()
    func hideFocusView()
    
    func showExposureModesView()
    func hideExposureModesView()
}