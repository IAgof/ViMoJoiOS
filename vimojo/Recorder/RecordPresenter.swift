//
//  RecordPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

struct IconsImage {
	var normal: UIImage!
	var pressed: UIImage!
}

class RecordPresenter: NSObject, RecordPresenterInterface, TimerInteractorDelegate {
	// MARK: - Variables VIPER
	var delegate: RecordPresenterDelegate?
	var cameraInteractor: CameraInteractorInterface?
	var timerInteractor: TimerInteractorInterface?
	
	var recordWireframe: RecordWireframe?
	var interactor: RecorderInteractorInterface?
	
	// MARK: - Variables
	var isRecording = false
	var secondaryViewIsShowing = false
	var videoSettingsConfigViewIsShowing = true
	var lastOrientationEnabled: Int?
	
	// MARK: - Showing controllers
	var gridIsShowed = false
	var zoomIsShowed = false
	var batteryIsShowed = false
	var spaceOnDiskIsShowed = false
	var resolutionIsShowed = false
	var isoConfigIsShowed = false
	var wbConfigIsShowed = false
	var micViewIsShowed = true
	var focusViewIsShowed = false
	var exposureModesViewIsShowed = false
	var micIsEnabled = false
	var modeViewIsShowed = true
	var inputGainViewIsShowed = false
	
	enum batteryImages: String {
		case charged = "activity_record_battery_100"
		case seventyFivePercent = "activity_record_battery_75"
		case fiftyPercent = "activity_record_battery_50"
		case twentyFivePercent = "activity_record_battery_25"
		case empty = "activity_record_battery_empty"
	}
	
	enum batteryImagesPressed: String {
		case charged = "activity_record_battery_100_pressed"
		case seventyFivePercent = "activity_record_battery_75_pressed"
		case fiftyPercent = "activity_record_battery_50_pressed"
		case twentyFivePercent = "activity_record_battery_25_pressed"
		case empty = "activity_record_battery_empty"
	}
	
	enum memoryImages: String {
		case hundredPercent = "activity_record_memory_100"
		case seventyFivePercent = "activity_record_memory_75"
		case fiftyPercent = "activity_record_memory_50"
		case twentyFivePercent = "activity_record_memory_25"
		case empty = "activity_record_memory_empty"
	}
	
	enum memoryImagesPressed: String {
		case hundredPercent = "activity_record_memory_100_pressed"
		case seventyFivePercent = "activity_record_memory_75_pressed"
		case fiftyPercent = "activity_record_memory_50_pressed"
		case twentyFivePercent = "activity_record_memory_25_pressed"
		case empty = "activity_record_memory_empty"
	}
	
	// MARK: - Event handler
	func viewDidLoad(parameters: RecorderParameters) {
		delegate?.configureView()
		cameraInteractor = CameraInteractor(delegate: self,
                                            parameters: parameters,
											project: (interactor?.getProject())!)
		// Checks wheter the mic is plugged in/out
		NotificationCenter.default.addObserver(self, selector:#selector(RecordPresenter.audioRouteChangeListener(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
		self.checkFlashAvaliable()
		self.checkIfMicIsAvailable()
		DispatchQueue.main.async(execute: {
			self.delegate?.enableIdleTimer(true)
		})
		self.pushHideMode()
	}
	
	func viewWillDisappear() {
		lastOrientationEnabled = UIDevice.current.orientation.rawValue
		DispatchQueue.global().async {
			if self.isRecording {
				self.stopRecord("")
			}
			FlashInteractor().turnOffWhenViewWillDissappear()
			DispatchQueue.main.async(execute: {
				self.delegate?.showFlashOn(false)
				self.delegate?.enableIdleTimer(false)
			})
		}
	}
	
	func viewWillAppear() {
		if let resolution = interactor?.getResolution() {
			delegate?.setResolutionToView(resolution)
		}
		
		self.updateThumbnail()
		
		DispatchQueue.main.async(execute: {
			self.delegate?.resizeAllIcons()
		})
	}
	
	func pushRecord(_ sender: String) {
		if isRecording {
			self.stopRecord(sender)
		} else {
			self.startRecord()
		}
	}
	
	func pushFlash() {
		let flashState = FlashInteractor().switchFlashState()
		delegate?.showFlashOn(flashState)
		self.trackFlash(flashState)
	}
	func pushVideoSettingsConfig() {
		if videoSettingsConfigViewIsShowing {
			videoSettingsConfigViewIsShowing = false
			
			delegate?.hideVideoSettingsConfig()
			hideAllModeConfigsIfNeccesary()
			delegate?.configModesButtonSelected(false)
		} else {
			videoSettingsConfigViewIsShowing = true
			
			delegate?.showVideoSettingsConfig()
			delegate?.configModesButtonSelected(true)
		}
	}
	
	func pushCameraSimple() {
		DispatchQueue.main.async(execute: {
			self.delegate?.hideUpperContainerView()
			self.delegate?.hideSettingsContainerView()
			self.delegate?.hideRecordButton()
			self.delegate?.hideClipsRecordedView()
			self.delegate?.hideDrawerButton()
			self.delegate?.hideResolutionView()
			self.hideAllModeConfigsIfNeccesary()
			self.delegate?.showCameraSimpleView()
			self.delegate?.hideSpaceOnDiskView()
			self.delegate?.hideBatteryView()
		})
	}
	
	func pushCameraPro() {
		DispatchQueue.main.async(execute: {
			self.delegate?.hideCameraSimpleView()
			self.delegate?.showUpperContainerView()
			self.delegate?.showSettingsContainerView()
			self.delegate?.showRecordButton()
			self.delegate?.showDrawerButton()
			self.delegate?.hideResolutionView()
			self.hideAllModeConfigsIfNeccesary()
			if (!self.isRecording) {
				self.delegate?.showClipsRecordedView()
			}
		})
	}
	
	func cameraViewHasTapped() {
		DispatchQueue.main.async(execute: {
			self.delegate?.hideResolutionView()
			self.delegate?.hideSpaceOnDiskView()
			self.delegate?.hideBatteryView()
		})
	}
	
	func pushHideAllButtons() {
		if secondaryViewIsShowing {
			delegate?.showPrincipalViews()
			self.showModeView()
			
			switchChronometerIfNeccesary()
			
			if videoSettingsConfigViewIsShowing {
				delegate?.showVideoSettingsConfig()
			}
			
			secondaryViewIsShowing = false
		} else {
			switchChronometerIfNeccesary()
			
			self.hideModeView()
			
			delegate?.hidePrincipalViews()
			
			hideZoomViewIfYouCan()
			hideAllModeConfigsIfNeccesary()
			
			secondaryViewIsShowing = true
		}
	}
	func switchChronometerIfNeccesary() {
		if isRecording {
			if secondaryViewIsShowing {
				delegate?.showRecordChronometerContainer()
				
				delegate?.hideSecondaryRecordChronometerContainer()
			} else {
				delegate?.showSecondaryRecordChronometerContainer()
				
				delegate?.hideRecordChronometerContainer()
			}
		}
	}
	func pushBattery() {
		if batteryIsShowed {
			hideBatteryViewIfYouCan()
		} else {
			hideSpaceOnDiskViewIfYouCan()
			hideResolutionViewIfYouCan()
			
			delegate?.updateBatteryValues()
			delegate?.showBatteryView()
			
			batteryIsShowed = true
		}
	}
	
	func pushSpaceOnDisk() {
		if spaceOnDiskIsShowed {
			hideSpaceOnDiskViewIfYouCan()
		} else {
			hideBatteryViewIfYouCan()
			hideResolutionViewIfYouCan()
			
			delegate?.updateSpaceOnDiskValues()
			delegate?.showSpaceOnDisk()
			
			spaceOnDiskIsShowed = true
		}
	}
	
	func pushResolution() {
		if resolutionIsShowed {
			hideResolutionViewIfYouCan()
		} else {
			hideBatteryViewIfYouCan()
			hideSpaceOnDiskViewIfYouCan()
			
			delegate?.showResolutionView()
			
			resolutionIsShowed = true
		}
	}
	
	func pushGain() {
		if inputGainViewIsShowed {
			hideInputGainIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			delegate?.selectInputGainSliderView()
			inputGainViewIsShowed = true
		}
	}
	
	func pushConfigMode(_ modePushed: VideoModeConfigurations) {
		switch modePushed {
		case .zomm:
			pushZoom()
			break
		case .exposure:
			pushExposureModes()
			
			break
		case .focus:
			pushFocus()
			
			break
		case .whiteBalance:
			pushWBConfig()
			
			break
		case .iso:
			pushISOConfig()
			break
			
		}
	}
	
	func pushGridMode() {
		if gridIsShowed {
			hideGridIfYouCan()
		} else {
			showGridView()
		}
	}
	
	func pushZoom() {
		if zoomIsShowed {
			hideZoomViewIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			
			showZoomView()
		}
	}
	
	func pushISOConfig() {
		if isoConfigIsShowed {
			hideISOConfigIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			
			delegate?.showISOConfigView()
			
			isoConfigIsShowed = true
		}
	}
	
	func pushWBConfig() {
		if wbConfigIsShowed {
			hideWBConfigIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			
			delegate?.showWBConfigView()
			
			wbConfigIsShowed = true
		}
	}
	
	func pushFocus() {
		if focusViewIsShowed {
			hideFocusIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			
			delegate?.showFocusView()
			
			focusViewIsShowed = true
		}
	}
	
	func pushExposureModes() {
		if exposureModesViewIsShowed {
			hideExposureModesIfYouCan()
		} else {
			hideAllModeConfigsIfNeccesary()
			
			delegate?.showExposureModesView()
			
			exposureModesViewIsShowed = true
		}
	}
	
	func pushDefaultModes() {
		hideFocusIfYouCan()
		hideISOConfigIfYouCan()
		hideZoomViewIfYouCan()
		hideWBConfigIfYouCan()
		hideExposureModesIfYouCan()
		hideGridIfYouCan()
		
		delegate?.setDefaultAllModes()
	}
	
	func pushCloseBatteryButton() {
		hideBatteryViewIfYouCan()
	}
	
	func pushCloseSpaceOnDiskButton() {
		hideSpaceOnDiskViewIfYouCan()
	}
	
	func resetRecorder() {
		delegate?.hideRecordedVideoThumb()
		interactor?.clearProject()
	}
	
	func checkFlashAvaliable() {
		let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
		if device?.hasTorch == false {
			delegate?.showFlashSupported(false)
		}
		
	}
	
	func getBatteryIcon(_ value: Float) -> IconsImage {
		switch value {
		case 0...10:
			return IconsImage(normal: UIImage(named: batteryImages.empty.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.empty.rawValue)!)
		case 11...25:
			return IconsImage(normal: UIImage(named: batteryImages.twentyFivePercent.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.twentyFivePercent.rawValue)!)
		case 26...50:
			return IconsImage(normal: UIImage(named: batteryImages.fiftyPercent.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.fiftyPercent.rawValue)!)
		case 51...75:
			return IconsImage(normal: UIImage(named: batteryImages.seventyFivePercent.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.seventyFivePercent.rawValue)!)
		case 76...100:
			return IconsImage(normal: UIImage(named: batteryImages.charged.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.charged.rawValue)!)
		default:
			return IconsImage(normal: UIImage(named: batteryImages.fiftyPercent.rawValue)!,
							  pressed: UIImage(named: batteryImagesPressed.fiftyPercent.rawValue)!)
		}
	}
	
	func getMemoryIcon(_ value: Float) -> IconsImage {
		switch value {
		case 0...10:
			return IconsImage(normal: UIImage(named: memoryImages.empty.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.empty.rawValue)!)
		case 10...25:
			return IconsImage(normal: UIImage(named: memoryImages.twentyFivePercent.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.twentyFivePercent.rawValue)!)
		case 26...50:
			return IconsImage(normal: UIImage(named: memoryImages.fiftyPercent.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.fiftyPercent.rawValue)!)
		case 51...75:
			return IconsImage(normal: UIImage(named: memoryImages.seventyFivePercent.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.seventyFivePercent.rawValue)!)
		case 76...100:
			return IconsImage(normal: UIImage(named: memoryImages.hundredPercent.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.hundredPercent.rawValue)!)
		default:
			return IconsImage(normal: UIImage(named: memoryImages.fiftyPercent.rawValue)!,
							  pressed: UIImage(named: memoryImagesPressed.fiftyPercent.rawValue)!)
		}
	}
	
	func batteryValuesUpdate(_ value: Float) {
		delegate?.setBatteryIcon(getBatteryIcon(value))
	}
	
	func memoryValuesUpdate(_ value: Float) {
		delegate?.setMemoryIcon(getMemoryIcon(value))
	}
	
	func audioLevelHasChanged(_ value: Float) {
		delegate?.setAudioColor(getAudioLevelColor(value))
	}
	
	func saveResolutionToDefaults(_ resolution: String) {
		
		interactor?.saveResolution(resolution: resolution)
		interactor?.getResolutionImage(resolution)
	}
	
	// MARK: - Inner functions
	func getAudioLevelColor(_ value: Float) -> UIColor {
		switch value {
		case 0 ... 0.5:
			return UIColor.green
		case 0.5 ... 0.6:
			return UIColor.yellow
		case 0.6 ... 0.8:
			return UIColor.orange
		case 0.8 ... 1:
			return UIColor.red
		default:
			return UIColor.green
		}
	}
	
	func startRecord() {
		
		self.trackStartRecord()
		
		delegate?.recordButtonEnable(false)
		delegate?.recordButtonSecondaryEnable(false)
		delegate?.buttonsWithRecording(isEnabled: false)
		
		DispatchQueue.main.async(execute: {
			self.cameraInteractor?.startRecording({answer in
				print("Record Presenter \(answer)")
				Utils().delay(1, closure: {
					self.delegate?.recordButtonEnable(true)
					self.delegate?.recordButtonSecondaryEnable(true)
				})
			})
			self.delegate?.selectRecordButton()
			self.delegate?.selectSecondaryRecordButton()
			self.delegate?.hideThumbnailButtonAndLabel()
			self.delegate?.startRecordingIndicatorBlink()
			self.delegate?.startSecondaryRecordingIndicatorBlink()
			self.delegate?.buttonsWithRecording(isEnabled: false)
			self.delegate?.showDrawerButton()
		})
		
		isRecording = true
		
		self.startTimer()
	}
	
	func stopRecord(_ sender: String) {
		self.trackStopRecord()
		delegate?.buttonsWithRecording(isEnabled: true)
		
		isRecording = false
		DispatchQueue.global().async {
			self.cameraInteractor?.stopRecording()
			DispatchQueue.main.async(execute: {
				self.delegate?.unselectSecondaryRecordButton()
				
				if sender == "pro" {
					self.delegate?.showThumbnailButtonAndLabel()
				}
				
				self.delegate?.selectRecordButton()
				self.delegate?.showStopButton()
				self.delegate?.stopRecordingIndicatorBlink()
				self.delegate?.hideDrawerButton()
			})
		}
		self.stopTimer()
	}
	
	func thumbnailHasTapped() {
		if let nClips = interactor?.getNumberOfClipsInProject() {
			if nClips > 0 {
				recordWireframe?.presentEditorRoomInterface()
			} else {
				recordWireframe?.presentGallery()
			}
		}
	}
	
	func pushShare() {
		recordWireframe?.presentShareInterfaceInsideEditorRoom()
	}
	
	func pushSettings() {
		self.trackSettingsPushed()
		recordWireframe?.presentSettingsInterface()
	}
	
	func pushShowMode() {
		delegate?.hideModeViewAndButtonStateDisabled()
		delegate?.showModeViewAndButtonStateEnabled()
		
		modeViewIsShowed = true
	}
	
	func pushHideMode() {
		//        delegate?.hideModeViewAndButtonStateEnabled()
		//        delegate?.showModeViewAndButtonStateDisabled()
		
		self.hideAllModeConfigsIfNeccesary()
		
		if !modeViewIsShowed {
			modeViewIsShowed = true
			delegate?.showVideoSettingsConfig()
			return
		}
		
		modeViewIsShowed = false
		delegate?.hideVideoSettingsConfig()
	}
	
	func hideGridIfYouCan() {
		if !gridIsShowed {
			return
		}
		
		delegate?.hideGridView()
		
		gridIsShowed = false
	}
	
	func showGridView() {
		delegate?.showGridView()
		
		gridIsShowed = true
	}
	
	func showZoomView() {
		delegate?.showZoomView()
		
		zoomIsShowed = true
	}
	
	func hideZoomViewIfYouCan() {
		if !zoomIsShowed {
			return
		}
		delegate?.hideZoomView()
		
		zoomIsShowed = false
	}
	
	func hideBatteryViewIfYouCan() {
		if !batteryIsShowed {
			return
		}
		delegate?.hideBatteryView()
		
		batteryIsShowed = false
	}
	
	func hideResolutionViewIfYouCan() {
		if !resolutionIsShowed {
			return
		}
		delegate?.hideResolutionView()
		
		resolutionIsShowed = false
	}
	
	func hideISOConfigIfYouCan() {
		if !isoConfigIsShowed {
			return
		}
		delegate?.hideISOConfigView()
		
		isoConfigIsShowed = false
	}
	
	func hideSpaceOnDiskViewIfYouCan() {
		if !spaceOnDiskIsShowed {
			return
		}
		delegate?.hideSpaceOnDiskView()
		
		spaceOnDiskIsShowed = false
	}
	
	func hideWBConfigIfYouCan() {
		if !wbConfigIsShowed {
			return
		}
		delegate?.hideWBConfigView()
		
		wbConfigIsShowed = false
	}
	
	func hideFocusIfYouCan() {
		if !focusViewIsShowed {
			return
		}
		delegate?.hideFocusView()
		
		focusViewIsShowed = false
	}
	
	func hideExposureModesIfYouCan() {
		if !exposureModesViewIsShowed {
			return
		}
		delegate?.hideExposureModesView()
		
		exposureModesViewIsShowed = false
	}
	
	func hideInputGainIfYouCan() {
		if !inputGainViewIsShowed {
			return
		}
		
		delegate?.deselectInputGainSliderView()
		inputGainViewIsShowed = false
	}
	
	func hideAllModeConfigsIfNeccesary() {
		hideWBConfigIfYouCan()
		hideISOConfigIfYouCan()
		hideFocusIfYouCan()
		hideExposureModesIfYouCan()
		hideZoomViewIfYouCan()
		
		hideInputGainIfYouCan()
	}
	
	func hideModeView() {
		if modeViewIsShowed {
			delegate?.hideModeViewAndButtonStateEnabled()
		} else {
			delegate?.hideModeViewAndButtonStateDisabled()
		}
	}
	
	func showModeView() {
		if modeViewIsShowed {
			delegate?.showModeViewAndButtonStateEnabled()
		} else {
			delegate?.showModeViewAndButtonStateDisabled()
		}
	}
	
	func checkIfMicIsAvailable() {
		let route = AVAudioSession.sharedInstance().currentRoute
		
		for port in route.outputs {
			if port.portType == AVAudioSessionPortHeadphones {
				// Headphones located
				setMicButtonState(true)
				setDeviceButtonState(false)
				delegate?.getMicValues()
			} else {
				setMicButtonState(false)
				setDeviceButtonState(true)
				delegate?.getMicValues()
			}
		}
	}
	
	func setMicButtonState(_ state: Bool) {
		if !state {
			delegate?.showJackMicButton()
			return
		} else {
			delegate?.hideJackMicButton()
		}
	}
	
	func setDeviceButtonState(_ state: Bool) {
		if !state {
			delegate?.showFrontMicButton()
		} else {
			delegate?.hideFrontMicButton()
		}
	}
	
	dynamic fileprivate func audioRouteChangeListener(_ notification: Notification) {
		let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
		
		switch audioRouteChangeReason {
		case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
			print("headphone plugged in")
			setMicButtonState(true)
			setDeviceButtonState(false)
		case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
			print("headphone pulled out")
			setMicButtonState(false)
			setDeviceButtonState(true)
		default:
			break
		}
	}
	
	func updateThumbnail( videoURL: URL? = nil) {
        print("hey")
		if let nClips = interactor?.getNumberOfClipsInProject() {
			if nClips > 0 {
				
				if let videoURL = videoURL ?? interactor?.getLastVideoURL() {
					let image = ThumbnailInteractor().thumbnailImage(videoURL)
					
					DispatchQueue.main.async(execute: {
						self.delegate?.showRecordedVideoThumb(image)
						
						self.delegate?.showNumberVideos((self.interactor?.getNumberOfClipsInProject())!)
					})
				}
				
			} else {
				self.delegate?.hideRecordedVideoThumb()
			}
		}
	}
	
	// MARK: - Track Events
	func trackFlash(_ flashState: Bool) {
		let tracker = ViMoJoTracker.sharedInstance
		if flashState {
			tracker.sendUserInteractedTracking((delegate?.getControllerName())!,
											   recording: isRecording,
											   interaction:AnalyticsConstants().CHANGE_FLASH,
											   result: "true")
		} else {
			tracker.sendUserInteractedTracking((delegate?.getControllerName())!,
											   recording: isRecording,
											   interaction:AnalyticsConstants().CHANGE_FLASH,
											   result: "false")
		}
	}
	
	func trackFrontCamera() {
		ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
																recording: isRecording,
																interaction:  AnalyticsConstants().CHANGE_CAMERA,
																result: AnalyticsConstants().CAMERA_FRONT)
	}
	
	func trackRearCamera() {
		ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
																recording: isRecording,
																interaction:  AnalyticsConstants().CHANGE_CAMERA,
																result: AnalyticsConstants().CAMERA_BACK)
	}
	
	func trackStartRecord() {
		ViMoJoTracker.sharedInstance.mixpanel.timeEvent(AnalyticsConstants().VIDEO_RECORDED)
		
		ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
																recording: isRecording,
																interaction:  AnalyticsConstants().RECORD,
																result: AnalyticsConstants().START)
	}
	
	func trackStopRecord() {
		ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
																recording: isRecording,
																interaction:  AnalyticsConstants().RECORD,
																result: AnalyticsConstants().STOP)
	}
	
	func trackSettingsPushed() {
		ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
																recording: isRecording,
																interaction:  AnalyticsConstants().INTERACTION_OPEN_SETTINGS,
																result: "")
	}
	
	// MARK: - Camera delegate
	func trackVideoRecorded(_ videoLenght: Double) {
		ViMoJoTracker.sharedInstance.trackTotalVideosRecordedSuperProperty()
		ViMoJoTracker.sharedInstance.updateTotalVideosRecorded()
	}
	
	func flashOn() {
		delegate?.showFlashOn(true)
	}
	
	func flashOff() {
		delegate?.showFlashOn(false)
	}
	
	func resetZoom() {
		delegate?.resetZoom()
	}
	
	func cameraRear() {
		delegate?.showBackCameraSelected()
		self.trackRearCamera()
		delegate?.showFlashSupported(true)
	}
	
	func cameraFront() {
		delegate?.showFrontCameraSelected()
		self.trackFrontCamera()
		delegate?.showFlashSupported(false)
	}
	
	func startTimer() {
		timerInteractor = TimerInteractor()
		timerInteractor!.setDelegate(self)
		
		timerInteractor?.start()
	}
	
	func stopTimer() {
		timerInteractor?.stop()
	}
	
	func showFocus(_ center: CGPoint) {
		delegate?.showFocusAtPoint(center)
	}
	
	// MARK: - Timer delegate
	func updateTimer(_ time: String) {
		delegate?.updateChronometer(time)
	}
	
}

extension RecordPresenter:RecorderInteractorDelegate {
	func resolutionImageFound(_ image: UIImage) {
		delegate?.setResolutionIconImage(image)
	}
	
	func resolutionImagePressedFound(_ image: UIImage) {
		delegate?.setResolutionIconImagePressed(image)
	}
}
