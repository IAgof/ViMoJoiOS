//
//  RecordPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage

class RecordPresenter: NSObject
    , RecordPresenterInterface
    ,CameraInteractorDelegate
,TimerInteractorDelegate
{
    
    //MARK: - Variables VIPER
    var delegate: RecordPresenterDelegate?
    var cameraInteractor: CameraInteractorInterface?
    var timerInteractor: TimerInteractorInterface?
    
    var recordWireframe: RecordWireframe?
    var thumbnailInteractor:ThumbnailInteractor?
    var interactor:RecorderInteractorInterface?
    
    //MARK: - Constants
    var isRecording = false
    var secondaryViewIsShowing = false
    var videoSettingsConfigViewIsShowing = true
    
    //MARK: - Showing controllers
    var zoomIsShowed = false
    var batteryIsShowed = false
    var spaceOnDiskIsShowed = false
    var isoConfigIsShowed = false
    var wbConfigIsShowed = false
    var exposureConfigIsShowed = false
    var micViewIsShowed = false
    var focusViewIsShowed = false
    var exposureModesViewIsShowed = false
    var micIsEnabled = false
    
    //MARK: - Event handler
    func viewDidLoad(displayView:GPUImageView){
        
        delegate?.configureView()
        cameraInteractor = CameraInteractor(display: displayView,
                                            cameraDelegate: self,
                                            project: (interactor?.getProject())! )
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(RecordPresenter.audioRouteChangeListener(_:)), name: AVAudioSessionRouteChangeNotification, object: nil)
        
        self.checkFlashAvaliable()
        self.checkIfMicIsAvailable()
    }
    
    func viewWillDisappear() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if self.isRecording{
                self.stopRecord()
            }
            FlashInteractor().turnOffWhenViewWillDissappear()
            dispatch_async(dispatch_get_main_queue(), {
                self.cameraInteractor?.stopCamera()
                self.delegate?.showFlashOn(false)
            })
        })
    }
    
    func viewWillAppear() {
        cameraInteractor!.setResolution()
        cameraInteractor?.startCamera()
        
        delegate?.forceOrientation()
    }
    
    func pushRecord() {
        if isRecording {
            self.stopRecord()
        }else{
            self.startRecord()
        }
    }
    
    func pushFlash() {
        let flashState = FlashInteractor().switchFlashState()
        delegate?.showFlashOn(flashState)
        self.trackFlash(flashState)
    }
    
    func pushRotateCamera() {
        cameraInteractor!.rotateCamera()
    }
    
    func pushVideoSettingsConfig() {
        if videoSettingsConfigViewIsShowing {
            videoSettingsConfigViewIsShowing = false
            
            delegate?.hideVideoSettingsConfig()
            hideAllModeConfigsIfNeccesary()
            delegate?.configModesButtonSelected(false)
        }else{
            videoSettingsConfigViewIsShowing = true
            
            delegate?.showVideoSettingsConfig()
            delegate?.configModesButtonSelected(true)
        }
    }
    
    func pushHideAllButtons() {
        if secondaryViewIsShowing{
            delegate?.showPrincipalViews()
            
            if videoSettingsConfigViewIsShowing {
                delegate?.showVideoSettingsConfig()
            }
            delegate?.hideSecondaryRecordViews()
            
            delegate?.showAllButtonsButtonImage()
            secondaryViewIsShowing = false
        }else{
            delegate?.showSecondaryRecordViews()
            delegate?.hidePrincipalViews()
            
            hideZoomViewIfYouCan()
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showHideAllButtonsButtonImage()
            secondaryViewIsShowing = true
        }
    }
    
    func pushBattery() {
        if batteryIsShowed{
            hideBatteryViewIfYouCan()
        }else{
            hideSpaceOnDiskViewIfYouCan()
            
            delegate?.updateBatteryValues()
            delegate?.showBatteryRemaining()
            
            batteryIsShowed = true
        }
    }
    
    func pushSpaceOnDisk() {
        if spaceOnDiskIsShowed{
            hideSpaceOnDiskViewIfYouCan()
        }else{
            hideBatteryViewIfYouCan()
            
            delegate?.updateSpaceOnDiskValues()
            delegate?.showSpaceOnDisk()
            
            spaceOnDiskIsShowed = true
        }
    }
    
    func pushMic() {
        if micIsEnabled{
            if micViewIsShowed{
                hideMicViewIfYouCan()
            }else{
                
                delegate?.getMicValues()
                delegate?.showMicLevelView()
                
                micViewIsShowed = true
            }
        }
    }
    
    func pushConfigMode(modePushed: VideoModeConfigurations) {
        switch modePushed {
        case .zomm:
            pushZoom()
            break
        case .exposure:
            pushExposureConfig()
            break
        case .focus:
            
            break
        case .whiteBalance:
            pushWBConfig()
            
            break
        case .iso:
            pushISOConfig()
            break
            
        }
    }
    
    
    func pushZoom() {
        if zoomIsShowed{
            hideZoomViewIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()

            showZoomView()
        }
    }
    
    func pushISOConfig() {
        if isoConfigIsShowed{
            hideISOConfigIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()

            delegate?.showISOConfigView()
            
            isoConfigIsShowed = true
        }
    }
    
    func pushWBConfig() {
        if wbConfigIsShowed{
            hideWBConfigIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showWBConfigView()
            
            wbConfigIsShowed = true
        }
    }
    
    func pushExposureConfig() {
        if exposureConfigIsShowed{
            hideExposureConfigIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showExposureConfigView()
            
            exposureConfigIsShowed = true
        }
    }
    
    func pushFocus() {
        if focusViewIsShowed{
            hideFocusIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showFocusView()
            
            focusViewIsShowed = true
        }
    }
    
    func pushExposureModes() {
        if exposureModesViewIsShowed{
            hideExposureModesIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showExposureModesView()
            
            exposureModesViewIsShowed = true
        }
    }
    
    func pushCloseBatteryButton() {
        hideBatteryViewIfYouCan()
    }
    
    func pushCloseSpaceOnDiskButton() {
        hideSpaceOnDiskViewIfYouCan()
    }
    
    func resetRecorder() {
        cameraInteractor?.removeFilters()
        
        interactor?.clearProject()
    }
    
    func checkFlashAvaliable(){
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasTorch == false{
            delegate?.showFlashSupported(false)
        }
        
    }

    enum batteryImages:String {
        case charged = "activity_record_icon_battery_charged"
        case seventyFivePercent = "activity_record_icon_battery_75"
        case fiftyPercent = "activity_record_icon_battery_50"
        case twentyFivePercent = "activity_record_icon_battery_25"
        case empty = "activity_record_icon_battery_empty"
    }
    
    func getBatteryIcon(value:Float)->UIImage {
        switch value {
        case 0...10:
            return UIImage(named: batteryImages.empty.rawValue)!
        case 11...25:
            return UIImage(named: batteryImages.twentyFivePercent.rawValue)!
        case 26...50:
            return UIImage(named: batteryImages.fiftyPercent.rawValue)!
        case 51...75:
            return UIImage(named: batteryImages.seventyFivePercent.rawValue)!
        case 76...100:
            return UIImage(named: batteryImages.charged.rawValue)!
        default:
            return UIImage(named: batteryImages.fiftyPercent.rawValue)!
        }
    }
    
    func batteryValuesUpdate(value: Float) {
        delegate?.setBatteryIcon(getBatteryIcon(value))
    }
    
    func audioLevelHasChanged(value: Float) {
        delegate?.setAudioColor(getAudioLevelColor(value))
    }
    
    //MARK: - Inner functions
    func getAudioLevelColor(value:Float)->UIColor{
        switch value {
        case 0 ... 0.5:
            return UIColor.greenColor()
        case 0.5 ... 0.6:
            return UIColor.yellowColor()
        case 0.6 ... 0.8:
            return UIColor.orangeColor()
        case 0.8 ... 1:
            return UIColor.redColor()
        default:
            return UIColor.greenColor()
        }
    }
    func startRecord(){
        self.trackStartRecord()
        
        delegate?.recordButtonEnable(false)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.cameraInteractor?.setIsRecording(true)
            
            self.cameraInteractor?.startRecordVideo({answer in
                print("Record Presenter \(answer)")
                Utils.sharedInstance.delay(1, closure: {
                    self.delegate?.recordButtonEnable(true)
                })
            })
            // update some UI
            self.delegate?.showRecordButton()
        })
        
        isRecording = true
        
        self.startTimer()
    }
    
    func stopRecord(){
        self.trackStopRecord()
        
        isRecording = false
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            self.cameraInteractor?.setIsRecording(false)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate?.showStopButton()
            });
        });
        
        self.stopTimer()
    }
    
    func thumbnailHasTapped() {
        let nClips = interactor?.getNumberOfClipsInProject()
        
        if nClips > 0{

        }else{

        }
    }

    func showZoomView(){
        delegate?.showZoomView()
        
        zoomIsShowed = true
    }
    
    func hideZoomViewIfYouCan(){
        if !zoomIsShowed {
            return
        }
        delegate?.hideZoomView()
        
        zoomIsShowed = false
    }
    
    func hideBatteryViewIfYouCan(){
        if !batteryIsShowed {
            return
        }
        delegate?.hideBatteryView()
        
        batteryIsShowed = false
    }
    
    func hideISOConfigIfYouCan(){
        if !isoConfigIsShowed {
            return
        }
        delegate?.hideISOConfigView()
        
        isoConfigIsShowed = false
    }
    
    func hideSpaceOnDiskViewIfYouCan(){
        if !spaceOnDiskIsShowed {
            return
        }
        delegate?.hideSpaceOnDiskView()
        
        spaceOnDiskIsShowed = false
    }
    
    func hideMicViewIfYouCan(){
        if !micViewIsShowed {
            return
        }
        delegate?.hideMicLevelView()
        
        micViewIsShowed = false
    }
    
    func hideWBConfigIfYouCan(){
        if !wbConfigIsShowed {
            return
        }
        delegate?.hideWBConfigView()
        
        wbConfigIsShowed = false
    }
    
    func hideExposureConfigIfYouCan(){
        if !exposureConfigIsShowed {
            return
        }
        delegate?.hideExposureConfigView()
        
        exposureConfigIsShowed = false
    }
    
    func hideFocusIfYouCan(){
        if !focusViewIsShowed {
            return
        }
        delegate?.hideFocusView()
        
        focusViewIsShowed = false
    }
    
    func hideExposureModesIfYouCan(){
        if !exposureModesViewIsShowed {
            return
        }
        delegate?.hideExposureModesView()
        
        exposureModesViewIsShowed = false
    }
    
    func hideAllModeConfigsIfNeccesary(){
        hideWBConfigIfYouCan()
        hideISOConfigIfYouCan()
        hideExposureConfigIfYouCan()
        hideFocusIfYouCan()
        hideExposureModesIfYouCan()
        hideZoomViewIfYouCan()
        
        hideMicViewIfYouCan()
    }
    
    
    func checkIfMicIsAvailable(){
        let route = AVAudioSession.sharedInstance().currentRoute
        
        for port in route.outputs {
            if port.portType == AVAudioSessionPortHeadphones {
                // Headphones located
                setMicButtonState(true)
            }else{
                setMicButtonState(false)
            }
        }
    }
    
    func setMicButtonState(state:Bool){
        delegate?.setSelectedMicButton(state)
        micIsEnabled = state
        
        if !state {
            hideMicViewIfYouCan()
        }
    }
    
    dynamic private func audioRouteChangeListener(notification:NSNotification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.NewDeviceAvailable.rawValue:
            print("headphone plugged in")
            setMicButtonState(true)
        case AVAudioSessionRouteChangeReason.OldDeviceUnavailable.rawValue:
            print("headphone pulled out")
            setMicButtonState(false)
        default:
            break
        }
    }
    
    //MARK: - Track Events
    func trackFlash(flashState:Bool){
        let tracker = ViMoJoTracker.sharedInstance
        if flashState {
            tracker.sendUserInteractedTracking((delegate?.getControllerName())!,
                                                recording: isRecording,
                                                interaction:AnalyticsConstants().CHANGE_FLASH,
                                                result: "true")
        }else{
            tracker.sendUserInteractedTracking((delegate?.getControllerName())!,
                                                recording: isRecording,
                                                interaction:AnalyticsConstants().CHANGE_FLASH,
                                                result: "false")
        }
    }
    
    func trackFrontCamera(){
        ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
                                                                  recording: isRecording,
                                                                  interaction:  AnalyticsConstants().CHANGE_CAMERA,
                                                                  result: AnalyticsConstants().CAMERA_FRONT)
    }
    
    func trackRearCamera(){
        ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
                                                                  recording: isRecording,
                                                                  interaction:  AnalyticsConstants().CHANGE_CAMERA,
                                                                  result: AnalyticsConstants().CAMERA_BACK)
    }
    
    func trackStartRecord(){
        ViMoJoTracker.sharedInstance.mixpanel.timeEvent(AnalyticsConstants().VIDEO_RECORDED);
        
        ViMoJoTracker.sharedInstance.sendUserInteractedTracking((delegate?.getControllerName())!,
                                                                  recording: isRecording,
                                                                  interaction:  AnalyticsConstants().RECORD,
                                                                  result: AnalyticsConstants().START)
    }
    
    func trackExported(videoTotalTime:Double) {
        ViMoJoTracker.sharedInstance.sendExportedVideoMetadataTracking(videoTotalTime,
                                                                              numberOfClips: (interactor?.getNumberOfClipsInProject())!)
    }
    
    func trackStopRecord(){
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
    
    //MARK: - Camera delegate
    func trackVideoRecorded(videoLenght:Double) {
        ViMoJoTracker.sharedInstance.trackTotalVideosRecordedSuperProperty()
        ViMoJoTracker.sharedInstance.sendVideoRecordedTracking(videoLenght)
        ViMoJoTracker.sharedInstance.updateTotalVideosRecorded()
    }
    
    func flashOn() {
        delegate?.showFlashOn(true)
    }
    
    
    func flashOff() {
        delegate?.showFlashOn(false)
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
    
    func showFocus(center: CGPoint) {
        delegate?.showFocusAtPoint(center)
    }
    
    //MARK: - Timer delegate
    func updateTimer(time: String) {
        delegate?.updateChronometer(time)
    }
    
    }