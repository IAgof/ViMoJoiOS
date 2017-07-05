//
//  RecordPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage
import VideonaProject

struct IconsImage {
    var normal : UIImage!
    var pressed : UIImage!
}

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
    var interactor:RecorderInteractorInterface?
    
    //MARK: - Variables
    var isRecording = false
    var secondaryViewIsShowing = false
    var videoSettingsConfigViewIsShowing = true
    var lastOrientationEnabled:Int?
    
    //MARK: - Showing controllers
    var gridIsShowed = false
    var zoomIsShowed = false
    var batteryIsShowed = false
    var spaceOnDiskIsShowed = false
    var resolutionIsShowed = false
    var isoConfigIsShowed = false
    var wbConfigIsShowed = false
    var micViewIsShowed = false
    var focusViewIsShowed = false
    var exposureModesViewIsShowed = false
    var micIsEnabled = false
    var modeViewIsShowed = false
    var inputGainViewIsShowed = false
    var isDeafaultActivate = true
    
    enum batteryImages:String {
        case charged = "activity_rec_battery_100"
        case seventyFivePercent = "activity_rec_battery_charging"
        case fiftyPercent = "activity_rec_battery_50"
        case twentyFivePercent = "activity_rec_battery_25"
        case empty = "activity_rec_battery_0"
    }
    
    enum batteryImagesPressed:String{
        case charged = "activity_rec_battery_100_pressed"
        case seventyFivePercent = "activity_rec_battery_charging_pressed"
        case fiftyPercent = "activity_rec_battery_50_pressed"
        case twentyFivePercent = "activity_rec_battery_25_pressed"
        case empty = "activity_rec_battery_0"
    }

    
    enum memoryImages:String {
        case hundredPercent = "activity_rec_memory_100"
        case fiftyPercent = "activity_rec_memory_50"
        case empty = "activity_rec_memory_0"
    }
    
    enum memoryImagesPressed:String{
        case hundredPercent = "activity_rec_memory_100"
        case fiftyPercent = "activity_rec_memory_50"
        case empty = "activity_rec_memory_0"
    }
    
    //MARK: - Event handler
    func viewDidLoad(_ displayView:GPUImageView){
        
        delegate?.configureView()
        cameraInteractor = CameraInteractor(display: displayView,
                                            cameraDelegate: self,
                                            project: (interactor?.getProject())! )
        NotificationCenter.default.addObserver(self, selector:#selector(RecordPresenter.audioRouteChangeListener(_:)), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
        
        self.checkFlashAvaliable()
        self.checkIfMicIsAvailable()
    }
    
    func viewWillDisappear() {
        lastOrientationEnabled = UIDevice.current.orientation.rawValue
        DispatchQueue.global().async {
            if self.isRecording{
                self.stopRecord()
            }
            FlashInteractor().turnOffWhenViewWillDissappear()
            DispatchQueue.main.async(execute: {
                self.cameraInteractor?.stopCamera()
                self.delegate?.showFlashOn(false)
            })
        }
    }
    
    func viewWillAppear() {
        cameraInteractor?.setResolution()
        cameraInteractor?.startCamera()
        
        if let resolution = interactor?.getResolution(){
            delegate?.setResolutionToView(resolution)
        }
        
        self.updateThumbnail()
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
            self.showModeView()
            
            switchChronometerIfNeccesary()

            
            if videoSettingsConfigViewIsShowing {
                delegate?.showVideoSettingsConfig()
            }
            // We don't want to make the grid fade in and out when hiding buttons
//            delegate?.hideSecondaryRecordViews()
            
            delegate?.showAllButtonsButtonImage()
            secondaryViewIsShowing = false
        }else{
            switchChronometerIfNeccesary()
            
            self.hideModeView()
            
//            delegate?.showSecondaryRecordViews()
            delegate?.hidePrincipalViews()
            
            hideZoomViewIfYouCan()
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showHideAllButtonsButtonImage()
            secondaryViewIsShowing = true
        }
    }
    func switchChronometerIfNeccesary(){
        if isRecording {
            if secondaryViewIsShowing {
                delegate?.showRecordChronometerContainer()
                
                delegate?.hideSecondaryRecordChronometerContainer()
            }else{
                delegate?.showSecondaryRecordChronometerContainer()
                
                delegate?.hideRecordChronometerContainer()
            }
        }
    }
    func pushBattery() {
        if batteryIsShowed{
            hideBatteryViewIfYouCan()
        }else{
            hideSpaceOnDiskViewIfYouCan()
            hideResolutionViewIfYouCan()
   
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
            hideResolutionViewIfYouCan()

            delegate?.updateSpaceOnDiskValues()
            delegate?.showSpaceOnDisk()
            
            spaceOnDiskIsShowed = true
        }
    }
    
    func pushResolution() {
        if resolutionIsShowed{
            hideResolutionViewIfYouCan()
        }else{
            hideBatteryViewIfYouCan()
            hideSpaceOnDiskViewIfYouCan()
            
            delegate?.showResolutionView()
            
            resolutionIsShowed = true
        }
    }
    
    func pushMic() {
        if micViewIsShowed {
            hideMicViewIfYouCan()
            hideInputGainIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showInputGainSliderView()
            delegate?.showMicLevelView()
            
            micViewIsShowed = true
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
    
    func pushFocus() {
        if focusViewIsShowed{
            hideFocusIfYouCan()
        }else{
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showFocusView()
            
            focusViewIsShowed = true
        }
    }
    
    func pushGrid() {
        if gridIsShowed {
            hideGridIfYouCan()
        } else {
            delegate?.showGrid()
            
            gridIsShowed = true
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
    
    func pushDefaultModes() {
        hideFocusIfYouCan()
        hideISOConfigIfYouCan()
        hideZoomViewIfYouCan()
        hideWBConfigIfYouCan()
        hideFocusIfYouCan()
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
        cameraInteractor?.removeFilters()
        delegate?.hideRecordedVideoThumb()
//        delegate?.disableShareButton()
        
        interactor?.clearProject()
    }
    
    func checkFlashAvaliable(){
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if device?.hasTorch == false{
            delegate?.showFlashSupported(false)
        }
        
    }
    
    func getBatteryIcon(_ value:Float)->IconsImage {
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
    
    func getMemoryIcon(_ value:Float)->IconsImage {
        switch value {
        case 0...50:
            return IconsImage(normal: UIImage(named: memoryImages.hundredPercent.rawValue)!,
                              pressed: UIImage(named: memoryImagesPressed.hundredPercent.rawValue)!)
        case 51...84:
            return IconsImage(normal: UIImage(named: memoryImages.fiftyPercent.rawValue)!,
                                    pressed: UIImage(named: memoryImagesPressed.fiftyPercent.rawValue)!)
        case 85...100:
            return IconsImage(normal: UIImage(named: memoryImages.empty.rawValue)!,
                              pressed: UIImage(named: memoryImagesPressed.empty.rawValue)!)
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
    
    func saveResolutionToDefaults(_ resolution:String) {
        
        interactor?.saveResolution(resolution: resolution)
        
        cameraInteractor?.setResolution()
        
        interactor?.getResolutionImage(resolution)
    }
    
    //MARK: - Inner functions
    func getAudioLevelColor(_ value:Float)->UIColor{
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
    func startRecord(){
        self.trackStartRecord()
        
        delegate?.recordButtonEnable(false)
        secondaryViewIsShowing ? delegate?.showSecondaryRecordChronometerContainer() :
                                    delegate?.showRecordChronometerContainer()
        delegate?.buttonsWithRecording(isEnabled: false)
        DispatchQueue.main.async(execute: {
            self.cameraInteractor?.setIsRecording(true)
            
            self.cameraInteractor?.startRecordVideo({answer in
                print("Record Presenter \(answer)")
                Utils().delay(1, closure: {
                    self.delegate?.recordButtonEnable(true)
                })
            })
            // update some UI
            self.delegate?.showRecordButton()
//            self.delegate?.disableShareButton()
            self.delegate?.hideThumbnailButtonAndLabel()
        })
        
        isRecording = true
        
        self.startTimer()
    }
    
    func stopRecord(){
        self.trackStopRecord()
        delegate?.buttonsWithRecording(isEnabled: true)
        
        isRecording = false
        DispatchQueue.global().async {
            // do some task
            self.cameraInteractor?.setIsRecording(false)
            
            DispatchQueue.main.async(execute: {
                self.delegate?.showStopButton()
                //                self.delegate?.enableShareButton()
                self.delegate?.showThumbnailButtonAndLabel()
                if self.secondaryViewIsShowing {
                    self.delegate?.hideSecondaryRecordChronometerContainer()
                }else{
                    self.delegate?.hideRecordChronometerContainer()
                }
            });
        }
        self.stopTimer()
    }
    
    func thumbnailHasTapped() {
        if let nClips = interactor?.getNumberOfClipsInProject(){
            if nClips > 0{
                recordWireframe?.presentEditorRoomInterface()
            }else{
                recordWireframe?.presentGallery()
            }
        }
    }

    func pushShare() {
        recordWireframe?.presentShareInterfaceInsideEditorRoom()
    }
    
    func pushSettings() {
        print("Record presenter pushSettings")
        self.trackSettingsPushed()
        recordWireframe?.presentSettingsInterface()
    }
    
    func pushShowMode() {
        delegate?.hideModeViewAndButtonStateDisabled()
        delegate?.showModeViewAndButtonStateEnabled()
        
        modeViewIsShowed = true
    }
    
    func pushHideMode() {
        delegate?.hideModeViewAndButtonStateEnabled()
        delegate?.showModeViewAndButtonStateDisabled()
        
        modeViewIsShowed = false
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
    
    func hideResolutionViewIfYouCan(){
        if !resolutionIsShowed {
            return
        }
        delegate?.hideResolutionView()
        
        resolutionIsShowed = false
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
    
    func hideGridIfYouCan() {
        if !gridIsShowed {
            return
        }
        
        delegate?.hideGrid()
        gridIsShowed = false
    }
    
    func hideInputGainIfYouCan(){
        if !inputGainViewIsShowed{
            return
        }
        
        delegate?.hideInputGainSliderView()
        inputGainViewIsShowed = false
    }
    
    func hideAllModeConfigsIfNeccesary(){
        hideWBConfigIfYouCan()
        hideISOConfigIfYouCan()
        hideFocusIfYouCan()
        hideExposureModesIfYouCan()
        hideZoomViewIfYouCan()
        stopDefaultIfYouCan()
        
        hideInputGainIfYouCan()
    }
    
    func hideModeView(){
        if modeViewIsShowed {
            delegate?.hideModeViewAndButtonStateEnabled()
        }else{
            delegate?.hideModeViewAndButtonStateDisabled()
        }
    }
    
    func stopDefaultIfYouCan(){
        if !isDeafaultActivate {
            return
        }
        delegate?.stopDefault()
        isDeafaultActivate = false
        
    }
    
    func showModeView(){
        if modeViewIsShowed {
            delegate?.showModeViewAndButtonStateEnabled()
        }else{
            delegate?.showModeViewAndButtonStateDisabled()
        }
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
    
    func setMicButtonState(_ state:Bool){
        delegate?.setSelectedMicButton(state)
        micIsEnabled = state
        
        if !state {
            hideMicViewIfYouCan()
            hideInputGainIfYouCan()
        }else{
            delegate?.getMicValues()
            delegate?.showMicLevelView()
            
            hideAllModeConfigsIfNeccesary()
            
            delegate?.showInputGainSliderView()
            inputGainViewIsShowed = true

            micViewIsShowed = true
        }
    }
    
    dynamic fileprivate func audioRouteChangeListener(_ notification:Notification) {
        let audioRouteChangeReason = notification.userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        
        switch audioRouteChangeReason {
        case AVAudioSessionRouteChangeReason.newDeviceAvailable.rawValue:
            print("headphone plugged in")
            setMicButtonState(true)
        case AVAudioSessionRouteChangeReason.oldDeviceUnavailable.rawValue:
            print("headphone pulled out")
            setMicButtonState(false)
        default:
            break
        }
    }
    
    func updateThumbnail( videoURL: URL? = nil) {
        if let nClips = interactor?.getNumberOfClipsInProject(){
            if nClips > 0{
                
                if let videoURL = videoURL ?? interactor?.getLastVideoURL() {
                    let image = ThumbnailInteractor().thumbnailImage(videoURL)
                    
                    DispatchQueue.main.async(execute: {
                        self.delegate?.showRecordedVideoThumb(image)
                        
                        self.delegate?.showNumberVideos((self.interactor?.getNumberOfClipsInProject())!)
                    });
                }

            }else{
                self.delegate?.hideRecordedVideoThumb()
                //            self.delegate?.disableShareButton()
            }
        }
    }
    
    //MARK: - Track Events
    func trackFlash(_ flashState:Bool){
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
    func trackVideoRecorded(_ videoLenght:Double) {
        ViMoJoTracker.sharedInstance.trackTotalVideosRecordedSuperProperty()
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
    
    func showFocus(_ center: CGPoint) {
        delegate?.showFocusAtPoint(center)
    }
    
    //MARK: - Timer delegate
    func updateTimer(_ time: String) {
        delegate?.updateChronometer(time)
    }
    
}

extension RecordPresenter:RecorderInteractorDelegate{
    func resolutionImageFound(_ image: UIImage) {
        delegate?.setResolutionIconImage(image)
    }
    
    func resolutionImagePressedFound(_ image: UIImage) {
        delegate?.setResolutionIconImagePressed(image)
    }
}
