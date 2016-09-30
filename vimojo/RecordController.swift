//
//  ViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import GPUImage
import SpaceOnDisk
import BatteryRemaining
import ISOConfiguration
import WhiteBalance
import Exposure
import AudioLevelBar
import Focus
import FocalLensSlider
import ExpositionModes
import ZoomCameraSlider
import ResolutionSelector

class RecordController: ViMoJoController,UINavigationControllerDelegate{
    
    //MARK: - Variables VIPER
    var eventHandler: RecordPresenterInterface?
    
    //MARK: Outlets
    //MARK: - UIButton
    @IBOutlet weak var cameraRotationButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var configModesButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resolutionButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!

    @IBOutlet weak var secondaryRecordButton: UIButton!
    @IBOutlet weak var hideAllButtonsButton: UIButton!
    @IBOutlet weak var batteryButton: UIButton!
    @IBOutlet weak var micButton: UIButton!

    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var isoButton: UIButton!
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var whiteBalanceButton: UIButton!
    @IBOutlet weak var exposureModesButton: UIButton!

    //MARK: - Custom
    @IBOutlet weak var cameraView: GPUImageView!
    @IBOutlet weak var batteryView: BatteryRemainingView!
    @IBOutlet weak var spaceOnDiskView: SpaceOnDiskView!
    @IBOutlet weak var isoConfigurationView: ISOConfigurationView!
    @IBOutlet weak var wbConfigurationView: WhiteBalanceView!
    @IBOutlet weak var exposureConfigurationView: ExposureView!
    @IBOutlet weak var overlayClearGrid: UIImageView!
    @IBOutlet weak var audioLevelView: AudioLevelBarView!
    @IBOutlet weak var focusView: FocusView!
    @IBOutlet weak var focalLensSliderView: FocalLensSliderView!
    @IBOutlet weak var expositionModesView: ExpositionModesView!
    @IBOutlet weak var zoomView: ZoomSliderView!
    @IBOutlet weak var resolutionsView: ResolutionsSelectorView!
    
    //MARK: - UIView
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var modeContainerView: UIView!
    @IBOutlet weak var recordAreaContainerView: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    
    //MARK: - UILabel
    @IBOutlet weak var secondaryChronometerLabel: UILabel!
    @IBOutlet weak var chronometrer: UILabel!
    
    @IBOutlet weak var secondaryRecordingIndicator: UIImageView!
    @IBOutlet weak var focusImageView: UIImageView!
    @IBOutlet weak var thumbnailNumberClips: UILabel!

    //MARK: - Variables
    var alertController:UIAlertController?
    var tapDisplay:UIGestureRecognizer?
    var pinchDisplay:UIPinchGestureRecognizer?
    
    var defaultThumbImage:UIImage{
        guard let image = UIImage(named: "activity_record_gallery_normal") else{
            return UIImage()
        }
        return image
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eventHandler?.viewDidLoad(cameraView)
        
        self.configureViews()
        
        configureRotationObserver()
    }
    
    func configureViews(){
        batteryView.delegate = self
        spaceOnDiskView.delegate = self
        audioLevelView.delegate = self
        focusView.delegate = self
        expositionModesView.delegate = self
        resolutionsView.delegate = self
        
        roundBorderOfViews()
        rotateZoomSlider()
        rotateFocalSlider()
        rotateExposureSlider()
        
        zoomView.setZoomSliderValue(0.0)
        self.thumbnailNumberClips.adjustsFontSizeToFitWidth = true
    }
    
    func configureTapDisplay(){
        tapDisplay = UITapGestureRecognizer(target: self, action: #selector(RecordController.displayTapped))
        self.cameraView.addGestureRecognizer(tapDisplay!)
    }

    func configurePinchDisplay(){
        pinchDisplay = UIPinchGestureRecognizer(target: self, action: #selector(RecordController.displayPinched))
        self.cameraView.addGestureRecognizer(pinchDisplay!)
    }
    
    func configureThumbnailTapObserver(){
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.thumbnailTapped))
        thumbnailView.userInteractionEnabled = true
        thumbnailView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func thumbnailTapped(){
        Utils.sharedInstance.debugLog("Thumbnail has tapped")
        
        eventHandler?.thumbnailHasTapped()
    }
    
    func configureRotationObserver(){
                NSNotificationCenter.defaultCenter().addObserver(self,
                                                                 selector: #selector(RecordController.checkOrientation),
                                                                 name: UIDeviceOrientationDidChangeNotification,
                                                                 object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Recorder view will appear")
        eventHandler?.viewWillAppear()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - View Config
    func forceLandsCapeOnInit(){
        //Force landscape mode
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    func configureView() {
        self.navigationController?.navigationBarHidden = true
        self.forceLandsCapeOnInit()
        
        configureTapDisplay()
        configurePinchDisplay()
        configureThumbnailTapObserver()
    }
    
    func displayPinched(){
        guard let scale = pinchDisplay?.scale else{return}
        guard let velocity = pinchDisplay?.velocity else{return}
        
        zoomView.setZoomWithPinchValues(scale,
                                        velocity:velocity)
    }
    
    func displayTapped(){
        focusView.tapViewPointAndViewFrame((tapDisplay?.locationInView(cameraView))!,
                                           frame: cameraView.frame)
        
        expositionModesView.tapViewPointAndViewFrame((tapDisplay?.locationInView(cameraView))!,
                                                     frame: cameraView.frame)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.LandscapeLeft
    }
    
    //MARK: - Button Actions
    @IBAction func pushRecord(sender: AnyObject) {
        eventHandler?.pushRecord()
    }
    
    @IBAction func pushFlash(sender: AnyObject) {
        eventHandler?.pushFlash()
    }
    
    @IBAction func pushRotateCamera(sender: AnyObject) {
        eventHandler?.pushRotateCamera()
    }
    
    @IBAction func pushVideoSettingsConfig(sender: AnyObject) {
        eventHandler?.pushVideoSettingsConfig()
    }
    
    @IBAction func pushHideButtons(sender: AnyObject) {
        eventHandler?.pushHideAllButtons()
    }
    
    @IBAction func pushZoom(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.zomm)
    }
    
    
    @IBAction func pushISO(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.iso)
    }
        
    
    @IBAction func pushMode(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushWhiteBalance(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.whiteBalance)
    }
    
    
    @IBAction func pushExposureModes(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.exposure)
    }
    
    
    @IBAction func pushFocus(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.focus)
    }
    
    
    @IBAction func pushBattery(sender: AnyObject) {
        eventHandler?.pushBattery()
    }
    
    
    @IBAction func pushMemory(sender: AnyObject) {
        eventHandler?.pushSpaceOnDisk()
    }
    
    
    @IBAction func pushResolution(sender: AnyObject) {
        eventHandler?.pushResolution()
    }
    
    
    @IBAction func pushGeolocalication(sender: AnyObject) {
        
    }
    
    @IBAction func pushMic(sender: AnyObject) {
        eventHandler?.pushMic()
    }
    
    @IBAction func pushShareButton(sender: AnyObject) {
        eventHandler?.pushShare()
    }
    
    @IBAction func pushSettingsButton(sender: AnyObject) {
        eventHandler?.pushSettings()
    }
    
    //MARK : - Inner functions
    
    func roundBorderOfViews() {
        upperContainerView.layer.cornerRadius = 4
        modeContainerView.layer.cornerRadius = 4
        zoomView.layer.cornerRadius = 4
        batteryView.layer.cornerRadius = 4
        spaceOnDiskView.layer.cornerRadius = 4
    }
    
    func rotateZoomSlider(){
        let trans = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        zoomView.transform = trans
    }
    
    func rotateFocalSlider(){
        let trans = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        focalLensSliderView.transform = trans
    }
    
    func rotateExposureSlider(){
        let trans = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        exposureConfigurationView.transform = trans
    }
    
    //MARK: - Landscape Orientation
    func checkOrientation(){
        var text=""
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            text="Portrait"
        case .PortraitUpsideDown:
            text="PortraitUpsideDown"
        case .LandscapeLeft:
            text="LandscapeLeft"
        case .LandscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        print("Orientation You have moved: \(text)")
    }
    
    func forceOrientation(orientationValue: Int) {
        UIDevice.currentDevice().setValue(orientationValue, forKey: "orientation")
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    
}

extension UINavigationController {
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let controller = visibleViewController{
            return controller.supportedInterfaceOrientations()
        }else{
            return UIInterfaceOrientationMask.Portrait
        }
    }
    public override func shouldAutorotate() -> Bool {
        if visibleViewController != nil{
            return visibleViewController!.shouldAutorotate()
        }else{
            return true
        }
    }
}

extension UIAlertController {
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    public override func shouldAutorotate() -> Bool {
        return false
    }
}

extension UIButton {
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        let largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (CGRectContainsPoint(largerFrame, point)) ? self : nil
    }
}

//MARK: - Inner functions
extension RecordController{
    func fadeInView(views:[UIView]){
        for view in views{
            view.hidden = false
        }
        
        UIView.animateWithDuration(0.5, animations: {
            for view in views{
                view.alpha = 0
            }
            
            for view in views{
                view.alpha = 1
            }
        })
    }
    
    func fadeOutView(views:[UIView]) {
        UIView.animateWithDuration(0.5, animations: {
            for view in views{
                view.alpha = 0
            }
            
            }, completion: {
                success in
                if success {
                    for view in views{
                        view.hidden = true
                    }
                }
        })
    }
    
    func setCornerToThumbnail(){
        let diameter = thumbnailView.frame.height/2
        
        thumbnailView.layer.cornerRadius = diameter
        thumbnailView.clipsToBounds = true
    }
    
    func setBorderToThumb(){
        let borderLayer = self.getBorderLayer()
        thumbnailView.layer.addSublayer(borderLayer)
    }
    
    func getBorderLayer() -> CALayer{
        let diameter = thumbnailView.frame.width/2
        let borderLayer = CALayer.init()
        let borderFrame = CGRectMake(0,0,thumbnailView.frame.height, thumbnailView.frame.height)
        
        //Set properties border layer
        borderLayer.backgroundColor = UIColor.clearColor().CGColor
        borderLayer.frame = borderFrame
        borderLayer.cornerRadius = diameter
        borderLayer.borderWidth = 3
        borderLayer.borderColor = UIColor.whiteColor().CGColor
        
        return borderLayer
    }
}

//MARK: - Presenter delegate
extension RecordController:RecordPresenterDelegate {
    //MARK: - Delegate Interface
    func showRecordButton(){
        self.recordButton.selected = true
        self.secondaryRecordButton.selected = true
    }
    
    func showStopButton(){
        self.recordButton.selected = false
        self.secondaryRecordButton.selected = false
    }
    
    func recordButtonEnable(state: Bool) {
        self.recordButton.enabled = state
        self.secondaryRecordButton.enabled = state
    }
    
    func configModesButtonSelected(state: Bool) {
        configModesButton.selected = state
    }
    
    func updateChronometer(time: String) {
        self.chronometrer.text = time
        self.secondaryChronometerLabel.text = time
    }
    
    func showRecordedVideoThumb(image: UIImage) {
        thumbnailView.image = image
        
        setCornerToThumbnail()
        setBorderToThumb()
    }
    
    func hideRecordedVideoThumb(){
        thumbnailView.image = defaultThumbImage
        thumbnailNumberClips.text = ""
        
        guard let sublayers = thumbnailView.layer.sublayers else{
            return
        }
        for layer in sublayers{
            layer.removeFromSuperlayer()
        }
    }
    
    func getThumbnailSize()->CGFloat{
        return self.thumbnailView.frame.size.height
    }
    
    func showNumberVideos(nClips:Int){
        thumbnailNumberClips.text = "\(nClips)"
        thumbnailNumberClips.adjustsFontSizeToFitWidth = true
    }
    
    func showFlashOn(on:Bool){
        flashButton.selected = on
    }
    
    func showFlashSupported(state:Bool){
        flashButton.enabled = state
    }
    
    func showFrontCameraSelected(){
        cameraRotationButton.selected = true
    }
    
    func showBackCameraSelected(){
        cameraRotationButton.selected = false
    }
    
    func resetView() {
        eventHandler?.resetRecorder()
    }
    
    func showFocusAtPoint(point: CGPoint) {
        
        focusImageView.center = point
        focusImageView.hidden = false
        
        Utils.sharedInstance.delay(0.5, closure: {
            self.focusImageView.hidden = true
        })
    }
    
    func showAllButtonsButtonImage() {
        hideAllButtonsButton.selected = false
    }
    
    func showHideAllButtonsButtonImage() {
        hideAllButtonsButton.selected = true
    }
    
    func hidePrincipalViews() {
        fadeOutView([modeContainerView,
            upperContainerView,
            recordAreaContainerView,
            thumbnailView,
            thumbnailNumberClips])
    }
    
    func showPrincipalViews() {
        fadeInView([upperContainerView,
            recordAreaContainerView,
            thumbnailView,
            thumbnailNumberClips])
    }
    
    func hideSecondaryRecordViews() {
        fadeOutView([secondaryRecordButton,secondaryChronometerLabel,secondaryRecordingIndicator,overlayClearGrid])
    }
    
    func showSecondaryRecordViews() {
        fadeInView([secondaryRecordButton,secondaryChronometerLabel,secondaryRecordingIndicator,overlayClearGrid])
    }
    
    func showVideoSettingsConfig() {
        fadeInView([modeContainerView])
    }
    
    func hideVideoSettingsConfig() {
        fadeOutView([modeContainerView])
    }
    
    func hideZoomView() {
        fadeOutView([zoomView])
        zoomButton.selected = false
    }
    
    func showZoomView() {
        fadeInView([zoomView])
        zoomButton.selected = true
    }
    
    func setBatteryIcon(image: UIImage) {
        batteryButton.setImage(image, forState: .Normal)
    }
    
    func setAudioColor(color: UIColor) {
        audioLevelView.setBarColor(color)
    }
    
    func showBatteryRemaining() {
        fadeInView([batteryView])
    }
    
    func showSpaceOnDisk() {
        fadeInView([spaceOnDiskView])
    }
    
    func updateBatteryValues() {
        batteryView.updateValues()
    }
    
    func hideBatteryView() {
        fadeOutView([batteryView])
    }
    
    func updateSpaceOnDiskValues() {
        spaceOnDiskView.updateValues()
    }
    
    func hideSpaceOnDiskView() {
        fadeOutView([spaceOnDiskView])
    }
    
    func showISOConfigView() {
        fadeInView([isoConfigurationView])
        isoButton.selected = true
    }
    
    func hideISOConfigView() {
        fadeOutView([isoConfigurationView])
        isoButton.selected = false
    }
    
    func showWBConfigView() {
        fadeInView([wbConfigurationView])
        whiteBalanceButton.selected = true
    }
    
    func hideWBConfigView() {
        fadeOutView([wbConfigurationView])
        whiteBalanceButton.selected = false
    }
    
    func getMicValues() {
        audioLevelView.getAudioLevel()
    }
    
    func showMicLevelView() {
        fadeInView([audioLevelView])
    }
    
    func hideMicLevelView() {
        fadeOutView([audioLevelView])
    }
    
    func setSelectedMicButton(state: Bool) {
        micButton.selected = state
    }
    
    func showFocusView() {
        fadeInView([focusView])
        focusView.checkIfFocalLensIsEnabled()
        
        focusButton.selected = true
    }
    
    func hideFocusView() {
        fadeOutView([focusView])
        fadeOutView([focalLensSliderView])
        focusButton.selected = false
    }
    
    func showResolutionView() {
        fadeInView([resolutionsView])
    }
    
    func hideResolutionView() {
        fadeOutView([resolutionsView])
    }
    
    func showExposureModesView() {
        fadeInView([expositionModesView])
        expositionModesView.checkIfExposureManualSliderIsEnabled()
        
        exposureModesButton.selected = true
    }
    
    func hideExposureModesView() {
        fadeOutView([expositionModesView])
        fadeOutView([exposureConfigurationView])

        exposureModesButton.selected = false
    }
    
    func setResolutionToView(resolution: String) {
        resolutionsView.setResolutionAtInit(resolution)
    }
    
    func setResolutionIconImage(image: UIImage) {
        resolutionButton.setImage(image, forState: .Normal)
    }
    func setResolutionIconImagePressed(image: UIImage) {
        resolutionButton.setImage(image, forState: .Highlighted)
        resolutionButton.setImage(image, forState: .Selected)
    }
    
    func enableShareButton() {
        shareButton.enabled = true
    }
    
    func disableShareButton() {
        shareButton.enabled = false
    }
}

//MARK: - BatteryRemaining delegate
extension RecordController:BatteryRemainingDelegate {
    func closeBatteryRemainingPushed() {
        eventHandler?.pushCloseBatteryButton()
    }
    func valuesUpdated(value: Float) {
        eventHandler?.batteryValuesUpdate(value)
    }
}

//MARK: - SpaceOnDisk delegate
extension RecordController:SpaceOnDiskDelegate {
    func closeSpaceOnDiskPushed() {
        eventHandler?.pushCloseSpaceOnDiskButton()
    }
}

//MARK: - AudioLevelBar delegate
extension RecordController:AudioLevelBarDelegate {
    func audioLevelChange(value: Float) {
        eventHandler?.audioLevelHasChanged(value)
    }
}

//MARK: - Focus delegate
extension RecordController:ExpositionModesDelegate {
    func showExpositionSlider() {
        fadeInView([exposureConfigurationView])
    }
    
    func hideExpositionSlider() {
        fadeOutView([exposureConfigurationView])
    }
}

//MARK: - Focus delegate
extension RecordController: FocusDelegate{
    func showFocusLens() {
        fadeInView([focalLensSliderView])
    }
    
    func hideFocusLens() {
        fadeOutView([focalLensSliderView])
    }
}

//MARK: - Resolutions delegate
extension RecordController: ResolutionsSelectorDelegate{
    func resolutionToChangeReceived(resolution: String) {
        eventHandler?.saveResolutionToDefaults(resolution)
    }
    
    func removeResolutionsView() {
        eventHandler?.pushResolution()
    }
}