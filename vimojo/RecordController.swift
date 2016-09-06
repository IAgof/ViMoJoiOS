//
//  ViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import GPUImage

class RecordController: ViMoJoController,UINavigationControllerDelegate,RecordPresenterDelegate {
    
    //MARK: - Variables VIPER
    var eventHandler: RecordPresenterInterface?
    
    //MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraRotationButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var secondaryRecordButton: UIButton!
    @IBOutlet weak var cameraView: GPUImageView!
    @IBOutlet weak var zoomSlider: UISlider!
    @IBOutlet weak var zoomSliderContainer: UIView!
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var modeContainerView: UIView!
    @IBOutlet weak var recordAreaContainerView: UIView!
    @IBOutlet weak var secondaryChronometerLabel: UILabel!
    @IBOutlet weak var chronometrer: UILabel!
    @IBOutlet weak var secondaryRecordingIndicator: UIImageView!
    @IBOutlet weak var focusImageView: UIImageView!
    @IBOutlet weak var hideAllButtonsButton: UIButton!
    
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
        
        roundBorderOfViews()
        
//        let trans = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
//        zoomSlider.transform = trans
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
        
    }
    
    
    @IBAction func pushISO(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushExposure(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushMode(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushWhiteBalance(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushAutomatic(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushFocus(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushBattery(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushMemory(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushResolution(sender: AnyObject) {
        
    }
    
    
    @IBAction func pushGeolocalication(sender: AnyObject) {
        
    }
    
    @IBAction func pushMic(sender: AnyObject) {
        
    }
    
    
    
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
        UIView.animateWithDuration(0.5, animations: {
            self.modeContainerView.alpha = 0
            self.upperContainerView.alpha = 0
            self.recordAreaContainerView.alpha = 0
        })
    }
    
    func showPrincipalViews() {
        UIView.animateWithDuration(0.5, animations: {
            self.modeContainerView.alpha = 1
            self.upperContainerView.alpha = 1
            self.recordAreaContainerView.alpha = 1
        })
    }
    
    func hideSecondaryRecordViews() {
        UIView.animateWithDuration(0.5, animations: {
            self.secondaryRecordButton.alpha = 0
            self.secondaryChronometerLabel.alpha = 0
            self.secondaryRecordingIndicator.alpha = 0
        })
    }
    
    func showSecondaryRecordViews() {
        UIView.animateWithDuration(0.5, animations: {
            self.secondaryRecordButton.alpha = 1
            self.secondaryChronometerLabel.alpha = 1
            self.secondaryRecordingIndicator.alpha = 1
        })
    }
    
    //MARK : - Inner functions
    
    func roundBorderOfViews() {
        upperContainerView.layer.cornerRadius = 4
        modeContainerView.layer.cornerRadius = 4
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
