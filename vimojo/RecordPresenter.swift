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
    var buttonsAreHidden = false
    var zoomIsShowed = false
    
    //MARK: - Event handler
    func viewDidLoad(displayView:GPUImageView){
        
        delegate?.configureView()
        cameraInteractor = CameraInteractor(display: displayView,
                                            cameraDelegate: self,
                                            project: (interactor?.getProject())! )
        
        self.checkFlashAvaliable()
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
    
    
    func pushSettings() {
        print("Record presenter pushSettings")
        self.trackSettingsPushed()
    }
    
    func pushShare() {
    }
    
    func pushFlash() {
        let flashState = FlashInteractor().switchFlashState()
        delegate?.showFlashOn(flashState)
        self.trackFlash(flashState)
    }
    
    func pushRecord() {
        if isRecording {
            self.stopRecord()
        }else{
            self.startRecord()
        }
    }
    
    func pushHideAllButtons() {
        if buttonsAreHidden{
            delegate?.showPrincipalViews()
            delegate?.hideSecondaryRecordViews()
            
            delegate?.showAllButtonsButtonImage()
            buttonsAreHidden = false
        }else{
            delegate?.showSecondaryRecordViews()
            delegate?.hidePrincipalViews()
            hideZoomViewIfYouCan()
            
            delegate?.showHideAllButtonsButtonImage()
            buttonsAreHidden = true
        }
    }
    
    func pushZoom() {
        if zoomIsShowed{
            hideZoomViewIfYouCan()
        }else{
            showZoomView()
        }
    }
    
    func zoomValueChanged(value: Float) {
        cameraInteractor?.zoom(value)
    }
    
    //////////////////////////////////////////
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
    //////////////////////////////////////////
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
    
    func pushRotateCamera() {
        cameraInteractor!.rotateCamera()
    }
    
    func thumbnailHasTapped() {
        let nClips = interactor?.getNumberOfClipsInProject()
        
        if nClips > 0{

        }else{

        }
    }
    
    func displayHasTapped(tapGesture:UIGestureRecognizer){
        cameraInteractor?.cameraViewTapAction(tapGesture)
    }
    
    func displayHasPinched(pinchGesture: UIPinchGestureRecognizer) {
        cameraInteractor?.zoom(pinchGesture)
    }
    
    func checkFlashAvaliable(){
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasTorch == false{
            delegate?.showFlashSupported(false)
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
    
    func resetRecorder() {
        cameraInteractor?.removeFilters()
        
        interactor?.clearProject()
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
    
    func zoomPinchedValueUpdate(value: CGFloat) {
        delegate?.setSliderValue(Float(value))
    }
    
    //MARK: - Timer delegate
    func updateTimer(time: String) {
        delegate?.updateChronometer(time)
    }
    
    }