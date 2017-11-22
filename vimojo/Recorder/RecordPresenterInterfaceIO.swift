//
//  RecordPresenterInterfaceIO.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol RecordPresenterInterface {
    func viewDidLoad(parameters: RecorderParameters)
    func viewWillDisappear()
    func viewWillAppear()

    func pushRecord(_ sender: String)
    func pushFlash()
    func pushVideoSettingsConfig()
    func thumbnailHasTapped()
    func pushShare()
    func pushSettings()

    func pushShowMode()
    func pushHideMode()

    func pushHideAllButtons()

	func pushGridMode()
    func pushZoom()
    func pushBattery()
    func pushSpaceOnDisk()
    func pushResolution()

    func pushGain()
    func pushFocus()
    func pushExposureModes()
    func pushDefaultModes()

    func pushConfigMode(_ modePushed: VideoModeConfigurations)

    func pushCloseBatteryButton()
    func pushCloseSpaceOnDiskButton()

    func resetRecorder()
    func checkFlashAvaliable()

    func batteryValuesUpdate(_ value: Float)
    func memoryValuesUpdate(_ value: Float)
    func audioLevelHasChanged(_ value: Float)

    func saveResolutionToDefaults(_ resolution: String)
	
	func pushCameraSimple()
	func pushCameraPro()
    
    func cameraViewHasTapped()
}

protocol RecordPresenterDelegate {
    func configureView()
    func recordButtonEnable(_ state: Bool)
    func recordButtonSecondaryEnable(_ state: Bool)
    func configModesButtonSelected(_ state: Bool)

    func showFlashOn(_ on: Bool)
    func showFlashSupported(_ state: Bool)
    func showBackCameraSelected()
    func showFrontCameraSelected()
    func showFocusAtPoint(_ point: CGPoint)
    func showStopButton()
    func showBatteryView()
    func showSpaceOnDisk()

    func getControllerName() -> String
    func updateChronometer(_ time: String)

    func showRecordedVideoThumb(_ image: UIImage)
    func hideRecordedVideoThumb()
    func getThumbnailSize() -> CGFloat
    func showNumberVideos(_ nClips: Int)

    func hidePrincipalViews()
    func showPrincipalViews()

    func hideSecondaryRecordViews()
    func showSecondaryRecordViews()

    func showVideoSettingsConfig()
    func hideVideoSettingsConfig()

	func showGridView()
	func hideGridView()

    func hideZoomView()
    func showZoomView()

    func setBatteryIcon(_ images: IconsImage)
    func setMemoryIcon(_ images: IconsImage)

    func setAudioColor(_ color: UIColor)

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
    func selectInputGainSliderView()
    func deselectInputGainSliderView()

    func showJackMicButton()
    func hideJackMicButton()

    func showFrontMicButton()
    func hideFrontMicButton()

    func showFocusView()
    func hideFocusView()

    func resetZoom()

    func showResolutionView()
    func hideResolutionView()

    func showExposureModesView()
    func hideExposureModesView()

    func setResolutionToView(_ resolution: String)
    func setResolutionIconImage(_ image: UIImage)
    func setResolutionIconImagePressed(_ image: UIImage)

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

    func setDefaultAllModes()
    func buttonsWithRecording(isEnabled: Bool)

    func selectDeviceMicButton()
    func selectJackMicButton()
    func deselectDeviceMicButton()
    func deselectJackMicButton()
	
	func hideUpperContainerView()
	func hideSettingsContainerView()
	func hideRecordButton()
	func hideDrawerButton()
	func hideClipsRecordedView()
	func hideCameraSimpleView()
	
	func showUpperContainerView()
	func showSettingsContainerView()
	func showRecordButton()
	func showDrawerButton()
    func showClipsRecordedView()
	func showCameraSimpleView()
    
    func startRecordingIndicatorBlink()
    func stopRecordingIndicatorBlink()
    func startSecondaryRecordingIndicatorBlink()
    func stopSecondaryRecordingIndicatorBlink()
    func selectRecordButton()
    func unselectRecordButton()
    func selectSecondaryRecordButton()
    func unselectSecondaryRecordButton()
    
    func resizeAllIcons()
	
	func enableIdleTimer(_ value: Bool)
}
