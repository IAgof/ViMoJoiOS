//
//  RecordPresenterInterfaceIO.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

protocol RecordPresenterInterface {
	func viewDidLoad(parameters: RecorderParameters)
    func viewWillDisappear()
    func viewWillAppear()

    func pushRecord()
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

    func saveResolutionToDefaults(_ resolution: String)
	
	func pushCameraSimple()
	func pushCameraPro()
    
    func cameraViewHasTapped()
	func hideAllModeConfigsIfNeccesary()

	func rotateCamera()
    func pushTutorial()
    
    func trackCameraViewTapped()
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

    func updateBatteryValues()
    func hideBatteryView()

    func updateSpaceOnDiskValues()
    func hideSpaceOnDiskView()

    func showISOConfigView()
    func hideISOConfigView()

    func showWBConfigView()
    func hideWBConfigView()

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

    func showRecordChronometerContainer()
    func hideRecordChronometerContainer()

    func showModeViewAndButtonStateEnabled()
    func hideModeViewAndButtonStateEnabled()
    func showModeViewAndButtonStateDisabled()
    func hideModeViewAndButtonStateDisabled()

    func showSecondaryRecordChronometerContainer()
    func hideSecondaryRecordChronometerContainer()

    func setDefaultAllModes()

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

	func blockCameraWhenRecording(_ value: Bool)
	func setDrawerGestureStatus(_ value: Bool)
	func enableIdleTimer(_ value: Bool)
    
    func settingsEnabled(_ value: Bool)
    func tutorialEnabled(_ sender: Bool)

	func checkCameraProSupportedFeatures()
    
    func showGainButton()
	func showGainSlider(_ value: Bool)
}
