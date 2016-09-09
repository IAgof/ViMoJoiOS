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

class RecordController: ViMoJoController,UINavigationControllerDelegate{
    
    //MARK: - Variables VIPER
    var eventHandler: RecordPresenterInterface?
    
    //MARK: Outlets
    //MARK: - UIButton
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraRotationButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var secondaryRecordButton: UIButton!
    @IBOutlet weak var hideAllButtonsButton: UIButton!
    @IBOutlet weak var batteryButton: UIButton!

    //MARK: - Custom
    @IBOutlet weak var cameraView: GPUImageView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var batteryView: BatteryRemainingView!
    @IBOutlet weak var spaceOnDiskView: SpaceOnDiskView!
    @IBOutlet weak var isoConfigurationView: ISOConfigurationView!
    @IBOutlet weak var wbConfigurationView: WhiteBalanceView!
    
    @IBOutlet weak var overlayClearGrid: UIImageView!
    
    //MARK: - UIView
    @IBOutlet weak var zoomSliderContainer: UIView!
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var modeContainerView: UIView!
    @IBOutlet weak var recordAreaContainerView: UIView!
    @IBOutlet weak var zoomContainerView: UIView!

    //MARK: - UILabel
    @IBOutlet weak var secondaryChronometerLabel: UILabel!
    @IBOutlet weak var chronometrer: UILabel!
    
    @IBOutlet weak var secondaryRecordingIndicator: UIImageView!
    @IBOutlet weak var focusImageView: UIImageView!
    
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
    }
    
    func configureViews(){
        batteryView.delegate = self
        spaceOnDiskView.delegate = self
        
        roundBorderOfViews()
        rotateSlider()
        zoomSlider.value = 0.0
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
    
    @IBAction func zoomSliderValueChanged(sender: AnyObject) {
        eventHandler?.zoomValueChanged(zoomSlider.value)
    }
    
    func configureView() {
        self.navigationController?.navigationBarHidden = true
        self.forceLandsCapeOnInit()
        
        pinchDisplay = UIPinchGestureRecognizer(target: self, action: #selector(RecordController.displayPinched))
        self.cameraView.addGestureRecognizer(pinchDisplay!)
    }
    
    func displayPinched(){
        eventHandler!.displayHasPinched(pinchDisplay!)
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
    
    @IBAction func pushGoToSettings(sender: AnyObject) {
        
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
    
    
    @IBAction func pushExposure(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushMode(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushWhiteBalance(sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.whiteBalance)
    }
    
    
    @IBAction func pushAutomatic(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushFocus(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushBattery(sender: AnyObject) {
        eventHandler?.pushBattery()
    }
    
    
    @IBAction func pushMemory(sender: AnyObject) {
        eventHandler?.pushSpaceOnDisk()
    }
    
    
    @IBAction func pushResolution(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushGeolocalication(sender: AnyObject) {
        
    }
    
    @IBAction func pushMic(sender: AnyObject) {
        
    }
    
     //MARK : - Inner functions
    
    func roundBorderOfViews() {
        upperContainerView.layer.cornerRadius = 4
        modeContainerView.layer.cornerRadius = 4
        zoomContainerView.layer.cornerRadius = 4
        batteryView.layer.cornerRadius = 4
        spaceOnDiskView.layer.cornerRadius = 4
    }
    
    func rotateSlider(){
        let trans = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        zoomSlider.transform = trans
    }
    
    //MARK: - Landscape Orientation
    func forceOrientation(){
        switch UIDevice.currentDevice().orientation{
        case .Portrait,.PortraitUpsideDown:
            let value = UIInterfaceOrientation.LandscapeRight.rawValue
            UIDevice.currentDevice().setValue(value, forKey: "orientation")
            Utils.sharedInstance.debugLog("Force orientation to landscape right)")
            break
        default:
            break
        }

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

//Animation for transitions fadeIn and fadeOut
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
    
    func updateChronometer(time: String) {
        self.chronometrer.text = time
        self.secondaryChronometerLabel.text = time
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
        fadeOutView([modeContainerView,upperContainerView,recordAreaContainerView])
    }
    
    func showPrincipalViews() {
        fadeInView([modeContainerView,upperContainerView,recordAreaContainerView])
    }
    
    func hideSecondaryRecordViews() {
        fadeOutView([secondaryRecordButton,secondaryChronometerLabel,secondaryRecordingIndicator,overlayClearGrid])
    }
    
    func showSecondaryRecordViews() {
        fadeInView([secondaryRecordButton,secondaryChronometerLabel,secondaryRecordingIndicator,overlayClearGrid])
    }
    
    func hideZoomView() {
        fadeOutView([zoomContainerView])
    }
    
    func showZoomView() {
        fadeInView([zoomContainerView])
    }
    
    func setSliderValue(value: Float) {
        zoomSlider.value = value
    }
    
    func setBatteryIcon(image: UIImage) {
        batteryButton.setImage(image, forState: .Normal)
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
    }
    
    func hideISOConfigView() {
        fadeOutView([isoConfigurationView])
    }
    
    func showWBConfigView() {
        fadeInView([wbConfigurationView])
    }
    
    func hideWBConfigView() {
        fadeOutView([wbConfigurationView])
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