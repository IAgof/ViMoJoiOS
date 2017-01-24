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
    func viewDidLoad(_ displayView:GPUImageView)
    func viewWillDisappear()
    func viewWillAppear()
    
    func pushRecord()
    func pushFlash()
    func pushRotateCamera()
    func pushVideoSettingsConfig()
    func thumbnailHasTapped()
    func pushShare()
    func pushSettings()
    
    func pushShowMode()
    func pushHideMode()
    
    func pushHideAllButtons()
    
    func pushZoom()
    func pushBattery()
    func pushSpaceOnDisk()
    func pushResolution()
    
    func pushMic()
    func pushFocus()
    func pushExposureModes()
    
    func pushConfigMode(_ modePushed:VideoModeConfigurations)
    
    func pushCloseBatteryButton()
    func pushCloseSpaceOnDiskButton()
    
    func resetRecorder()
    func checkFlashAvaliable()
    
    func batteryValuesUpdate(_ value:Float)
    func audioLevelHasChanged(_ value:Float)
    
    func saveResolutionToDefaults(_ resolution:String)
}

protocol RecordPresenterDelegate {
    func configureView()
    func recordButtonEnable(_ state:Bool)
    func configModesButtonSelected(_ state:Bool)
   
    func showFlashOn(_ on:Bool)
    func showRecordButton()
    func showFlashSupported(_ state:Bool)
    func showBackCameraSelected()
    func showFrontCameraSelected()
    func showFocusAtPoint(_ point:CGPoint)
    func showStopButton()
    func showHideAllButtonsButtonImage()
    func showAllButtonsButtonImage()
    func showBatteryRemaining()
    func showSpaceOnDisk()
    
    func getControllerName()->String
    func updateChronometer(_ time:String)
    
    func showRecordedVideoThumb(_ image: UIImage)
    func hideRecordedVideoThumb()
    func getThumbnailSize()->CGFloat
    func showNumberVideos(_ nClips:Int)

    func hidePrincipalViews()
    func showPrincipalViews()
    
    func hideSecondaryRecordViews()
    func showSecondaryRecordViews()
    
    func showVideoSettingsConfig()
    func hideVideoSettingsConfig()
    
    func hideZoomView()
    func showZoomView()
    
    func setBatteryIcon(_ images:BatteryIconImage)
    func setBatteryIconPressed(_ image:UIImage)
    
    func setAudioColor(_ color:UIColor)
    
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
    func showInputGainSliderView()
    func hideInputGainSliderView()
    func setSelectedMicButton(_ state:Bool)
    
    func showFocusView()
    func hideFocusView()
    
    func showResolutionView()
    func hideResolutionView()
    
    func showExposureModesView()
    func hideExposureModesView()
    
    func setResolutionToView(_ resolution:String)
    func setResolutionIconImage(_ image:UIImage)
    func setResolutionIconImagePressed(_ image:UIImage)
    
//    func enableShareButton()
//    func disableShareButton()
    
    func hideThumbnailButtonAndLabel()
    func showThumbnailButtonAndLabel()
    
    func showRecordChronometerContainer()
    func hideRecordChronometerContainer()
    
    func showModeViewAndButtonStateEnabled()
    func hideModeViewAndButtonStateEnabled()
    func showModeViewAndButtonStateDisabled()
    func hideModeViewAndButtonStateDisabled()
    
    func showSecondaryRecordChronometerContainer()
    func hideSecondaryRecordChronometerContainer()
}
