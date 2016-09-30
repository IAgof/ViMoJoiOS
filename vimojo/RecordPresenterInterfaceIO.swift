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
    func thumbnailHasTapped()
    func pushShare()
    func pushSettings()
    
    func pushHideAllButtons()
    
    func pushZoom()
    func pushBattery()
    func pushSpaceOnDisk()
    func pushResolution()
    
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
    
    func saveResolutionToDefaults(resolution:String)
}

protocol RecordPresenterDelegate {
    func configureView()
    func forceOrientation(orientationValue:Int)
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
    
    func showRecordedVideoThumb(image: UIImage)
    func hideRecordedVideoThumb()
    func getThumbnailSize()->CGFloat
    func showNumberVideos(nClips:Int)

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
    
    func getMicValues()
    func showMicLevelView()
    func hideMicLevelView()
    func setSelectedMicButton(state:Bool)
    
    func showFocusView()
    func hideFocusView()
    
    func showResolutionView()
    func hideResolutionView()
    
    func showExposureModesView()
    func hideExposureModesView()
    
    func setResolutionToView(resolution:String)
    func setResolutionIconImage(image:UIImage)
    func setResolutionIconImagePressed(image:UIImage)
    
    func enableShareButton()
    func disableShareButton()
}