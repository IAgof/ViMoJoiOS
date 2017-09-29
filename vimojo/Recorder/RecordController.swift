//
//  ViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import GPUImage
import VideonaProject

class RecordController: ViMoJoController, UINavigationControllerDelegate {
    // MARK: - Variables VIPER
    var eventHandler: RecordPresenterInterface?

    // MARK: Outlets
    // MARK: - UIButton
    @IBOutlet weak var warningOrientationImage: UIImageView!
    @IBOutlet weak var cameraRotationButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var configModesButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var secondaryRecordButton: UIButton!
    @IBOutlet weak var resolutionButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
//    @IBOutlet weak var showModeViewButton: UIButton!
    @IBOutlet weak var hideModeViewButton: UIButton!

    @IBOutlet weak var batteryButton: UIButton!
    @IBOutlet weak var jackMicButton: UIButton!
    @IBOutlet weak var gainButton: UIButton!
    @IBOutlet weak var deviceMicButton: UIButton!
    @IBOutlet weak var storageButton: UIButton!

    @IBOutlet weak var gridButton: UIButton!
	@IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var isoButton: UIButton!
    @IBOutlet weak var exposureButton: UIButton!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var whiteBalanceButton: UIButton!
    @IBOutlet weak var exposureModesButton: UIButton!
    @IBOutlet weak var defaultModesButton: UIButton!
    @IBOutlet weak var recordAreaContainerView: UIView!

    @IBOutlet weak var drawerButtonRight: UIButton!

    // MARK: - Custom
    @IBOutlet weak var cameraView: GPUImageView!
    @IBOutlet weak var batteryView: BatteryRemainingView!
    @IBOutlet weak var spaceOnDiskView: SpaceOnDiskView!
    @IBOutlet weak var isoConfigurationView: ISOConfigurationView!
    @IBOutlet weak var wbConfigurationView: WhiteBalanceView!
    @IBOutlet weak var exposureConfigurationView: ExposureView!
    @IBOutlet weak var overlayGrid: UIImageView!
    @IBOutlet weak var audioLevelView: AudioLevelBarView!
    @IBOutlet weak var focusView: FocusView!
    @IBOutlet weak var focalLensSliderView: FocalLensSliderView!
    @IBOutlet weak var expositionModesView: ExpositionModesView!
    @IBOutlet weak var zoomView: ZoomSliderView!
    @IBOutlet weak var resolutionsView: ResolutionsSelectorView!
    @IBOutlet weak var inputGainSlider: InputSoundGainControlView!

    // MARK: - UIView
    @IBOutlet weak var upperContainerView: UIView!
    @IBOutlet weak var secondaryChronometerContainer: UIView!
    @IBOutlet weak var modeContainerView: UIView!
//    @IBOutlet weak var chronometerContainerView: UIView!
    @IBOutlet weak var thumbnailViewParent: UIView!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var secondaryThumbnailView: UIImageView!
    @IBOutlet weak var chronometerImageView: UIImageView!
	@IBOutlet weak var cameraSimpleView: UIView!

    // MARK: - UILabel
    @IBOutlet weak var secondaryChronometerLabel: UILabel!
    @IBOutlet weak var chronometrer: UILabel!

    @IBOutlet weak var recordingIndicator: UIImageView!
    @IBOutlet weak var secondaryRecordingIndicator: UIImageView!
    @IBOutlet weak var secondaryThumbnailNumberClips: UILabel!
    @IBOutlet weak var focusImageView: UIImageView!
    @IBOutlet weak var thumbnailNumberClips: UILabel!
    @IBOutlet weak var thumbnailInfoLabel: UILabel!

    // MARK: - Variables
    var alertController: UIAlertController?
    var tapDisplay: UIGestureRecognizer?
    var pinchDisplay: UIPinchGestureRecognizer?

    var defaultThumbImage: UIImage {
        guard let image = UIImage(named: "activity_rec_gallery") else {
            return UIImage()
        }
        return image
    }

    // MARK: - Constants
    let cornerRadius = CGFloat(4)

    override var isStatusBarHidden: Bool {
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Let's see how can we erase GPUImage and introduce AVFoundation on this step
        eventHandler?.viewDidLoad(cameraView)
        self.configureViews()
        // Try to allow rotation -- It's just boring to landscape the capture in a static mode
        configureRotationObserver()
        // Is that real? I'd say our app tends to be interactive, specially in camera pro. I'd switch when recording to camera pro this value.
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Recorder view will appear")
        eventHandler?.viewWillAppear()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        drawerButtonRight.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()

        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        drawerButtonRight.isHidden = true
    }

    func configureViews() {
        // Allow protocols to be injected in this controller as extensions of RecordController class
        batteryView.delegate = self
        spaceOnDiskView.delegate = self
        audioLevelView.delegate = self
        focusView.delegate = self
        expositionModesView.delegate = self
        resolutionsView.delegate = self

        // Setting some initial status
        batteryView.updateValues()
        spaceOnDiskView.updateValues()
        zoomView.setZoomSliderValue(0.0)
        
        // Styling some views
        roundBorderOfViews()
        rotateZoomSlider()
        rotateFocalSlider()
        rotateExposureSlider()
        rotateInputGainSlider()

        self.thumbnailNumberClips.adjustsFontSizeToFitWidth = true
        secondaryChronometerLabel.adjustsFontSizeToFitWidth = true
    }

    func configureTapDisplay() {
        tapDisplay = UITapGestureRecognizer(target: self, action: #selector(RecordController.displayTapped))
        self.cameraView.addGestureRecognizer(tapDisplay!)
    }

    func configurePinchDisplay() {
        pinchDisplay = UIPinchGestureRecognizer(target: self, action: #selector(RecordController.displayPinched))
        self.cameraView.addGestureRecognizer(pinchDisplay!)
    }

    func configureThumbnailTapObserver() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.thumbnailTapped))
		let secondaryTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.thumbnailTapped))
        thumbnailView.isUserInteractionEnabled = true
        secondaryThumbnailView.isUserInteractionEnabled = true
        thumbnailView.addGestureRecognizer(tapGestureRecognizer)
        secondaryThumbnailView.addGestureRecognizer(secondaryTapGestureRecognizer)
    }

    func thumbnailTapped() {
        Utils().debugLog("Thumbnail has tapped")

        eventHandler?.thumbnailHasTapped()
    }

    func configureRotationObserver() {
                NotificationCenter.default.addObserver(self,
                                                                 selector: #selector(RecordController.checkOrientation),
                                                                 name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                                 object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View Config
    func configureView() {
        self.navigationController?.isNavigationBarHidden = true

        configureTapDisplay()
        configurePinchDisplay()
        configureThumbnailTapObserver()
    }

    func displayPinched() {
        guard let scale = pinchDisplay?.scale else {return}
        guard let velocity = pinchDisplay?.velocity else {return}

        zoomView.setZoomWithPinchValues(scale,
                                        velocity:velocity)
    }

    func displayTapped() {
        focusView.tapViewPointAndViewFrame((tapDisplay?.location(in: cameraView))!,
                                           frame: cameraView.frame)

        expositionModesView.tapViewPointAndViewFrame((tapDisplay?.location(in: cameraView))!,
                                                     frame: cameraView.frame)
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
	
	@IBAction func pushSettings(_ sender: AnyObject) {
		eventHandler?.pushSettings()
	}
	
	@IBAction func pushCameraSimple(_ sender: AnyObject) {
		eventHandler?.pushCameraSimple()
	}
	
	@IBAction func pushCameraPro(_ sender: AnyObject) {
		eventHandler?.pushCameraPro()
	}
	
	@IBAction func pushMemory(_ sender: AnyObject) {
		eventHandler?.pushSpaceOnDisk()
	}

    // MARK: - Button Actions
    @IBAction func pushRecord(_ sender: AnyObject) {
        eventHandler?.pushRecord("pro")
    }
    
    @IBAction func pushRecordSecondary(_ sender: AnyObject) {
        eventHandler?.pushRecord("simple")
    }

    @IBAction func pushFlash(_ sender: AnyObject) {
        eventHandler?.pushFlash()
    }

    @IBAction func pushRotateCamera(_ sender: AnyObject) {
        eventHandler?.pushRotateCamera()
    }

    @IBAction func pushVideoSettingsConfig(_ sender: AnyObject) {
        eventHandler?.pushVideoSettingsConfig()
    }

    @IBAction func pushHideMode(_ sender: AnyObject) {
        eventHandler?.pushHideMode()
    }

    @IBAction func pushHideButtons(_ sender: AnyObject) {
        eventHandler?.pushHideAllButtons()
    }

    @IBAction func pushGrid(_ sender: AnyObject) {
        eventHandler?.pushGridMode()
    }

	@IBAction func pushZoom(_ sender: AnyObject) {
		eventHandler?.pushConfigMode(VideoModeConfigurations.zomm)
	}

    @IBAction func pushISO(_ sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.iso)
    }

    @IBAction func pushDefaultModes(_ sender: Any) {
        eventHandler?.pushDefaultModes()
    }

    @IBAction func pushWhiteBalance(_ sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.whiteBalance)
    }

    @IBAction func pushExposureModes(_ sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.exposure)
    }

    @IBAction func pushFocus(_ sender: AnyObject) {
        eventHandler?.pushConfigMode(VideoModeConfigurations.focus)
    }

    @IBAction func pushBattery(_ sender: AnyObject) {
        eventHandler?.pushBattery()
    }

    @IBAction func pushResolution(_ sender: AnyObject) {
        eventHandler?.pushResolution()
    }

    // Display or hide the gain slider depending of its status
    @IBAction func pushGain(_ sender: AnyObject) {
        eventHandler?.pushGain()
    }

    @IBAction func pushShareButton(_ sender: AnyObject) {
        eventHandler?.pushShare()
    }

    @IBAction func showSideDrawer(_ sender: AnyObject) {
        print("Show side drawer")
        var parent = self.parent
        while parent != nil {
            if let drawer = parent as? KYDrawerController {
                drawer.setDrawerState(.opened, animated: true)
            }
            parent = parent?.parent
        }
    }

    //MARK : - Inner functions

    func roundBorderOfViews() {
        var viewsToBorder: [UIView] = []

        viewsToBorder.append(upperContainerView)
        viewsToBorder.append(modeContainerView)
        viewsToBorder.append(zoomView)
        viewsToBorder.append(batteryView)
        viewsToBorder.append(spaceOnDiskView)
//        viewsToBorder.append(chronometerContainerView)
        viewsToBorder.append(secondaryChronometerLabel)
        viewsToBorder.append(isoConfigurationView)
        viewsToBorder.append(focusView)
        viewsToBorder.append(wbConfigurationView)
        viewsToBorder.append(expositionModesView)
        viewsToBorder.append(focalLensSliderView)
        viewsToBorder.append(inputGainSlider)
        viewsToBorder.append(exposureConfigurationView)
        
        for view in viewsToBorder {
            view.layer.cornerRadius = cornerRadius
        }
    }
    
    func resizeAllIcons() {
        defaultModesButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        gridButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        isoButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        whiteBalanceButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        focusButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        exposureModesButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        gainButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        flashButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        cameraRotationButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        zoomButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        hideModeViewButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
    }

    func rotateZoomSlider() {
        let trans = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        zoomView.transform = trans
    }

    func rotateFocalSlider() {
        let trans = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        focalLensSliderView.transform = trans
    }

    func rotateExposureSlider() {
        let trans = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        exposureConfigurationView.transform = trans
    }

    func rotateInputGainSlider() {
        let trans = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        inputGainSlider.transform = trans
    }

    // MARK: - Landscape Orientation
    func checkOrientation() {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            warningOrientationImage.isHidden = false
        case .landscapeLeft, .landscapeRight:
            warningOrientationImage.isHidden = true
        default:
            warningOrientationImage.isHidden = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }

    public func setNavigationBarHidden(isHidden state: Bool) {
        self.navigationController?.isNavigationBarHidden = state
    }
}

extension UINavigationController {

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let controller = visibleViewController {
            return controller.supportedInterfaceOrientations
        } else {
            return UIInterfaceOrientationMask.portrait
        }
    }
    open override var shouldAutorotate: Bool {
        if visibleViewController != nil {
            return visibleViewController!.shouldAutorotate
        } else {
            return true
        }
    }
}

extension UIAlertController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}

extension UIButton {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let buttonSize = self.frame.size
        let widthToAdd = (44-buttonSize.width > 0) ? 44-buttonSize.width : 0
        let heightToAdd = (44-buttonSize.height > 0) ? 44-buttonSize.height : 0
        let largerFrame = CGRect(x: 0-(widthToAdd/2), y: 0-(heightToAdd/2), width: buttonSize.width+widthToAdd, height: buttonSize.height+heightToAdd)
        return (largerFrame.contains(point)) ? self : nil
    }
}

// MARK: - Inner functions
extension RecordController {
    func fadeInView(_ views: [UIView]) {
        for view in views {
            view.isHidden = false
        }

        UIView.animate(withDuration: 0.5, animations: {
            for view in views {
                view.alpha = 0
            }

            for view in views {
                view.alpha = 1
            }
        })
    }

    func fadeOutView(_ views: [UIView]) {
        UIView.animate(withDuration: 0.5, animations: {
            for view in views {
                view.alpha = 0
            }

            }, completion: {
                success in
                if success {
                    for view in views {
                        view.isHidden = true
                    }
                }
        })
    }

    func setCornerToThumbnail() {
        var height = thumbnailView.size.height
        var diameter = height/2

        thumbnailView.cornerRadius = diameter
        thumbnailView.borderColor = .white
        thumbnailView.borderWidth = 1
        
        height = secondaryThumbnailView.size.height
        diameter = height/2
        
        secondaryThumbnailView.cornerRadius = diameter
        secondaryThumbnailView.borderColor = .white
        secondaryThumbnailView.borderWidth = 1
    }
}

// MARK: - Presenter delegate
extension RecordController:RecordPresenterDelegate {
    // MARK: - Delegate Interface

    func showStopButton() {
        self.recordButton.isSelected = false
    }

    func recordButtonEnable(_ state: Bool) {
        self.recordButton.isEnabled = state
    }
    
    func recordButtonSecondaryEnable(_ state: Bool) {
        self.secondaryRecordButton.isEnabled = state
    }
    
    func configModesButtonSelected(_ state: Bool) {
        configModesButton.isSelected = state
    }

    func updateChronometer(_ time: String) {
        self.chronometrer.text = time
        self.secondaryChronometerLabel.text = time
    }

    func showRecordedVideoThumb(_ image: UIImage) {
        setCornerToThumbnail()
        thumbnailView.image = image
        thumbnailInfoLabel.text = "Editor".localize(inTable: "Settings")
        secondaryThumbnailView.image = image
    }

    func hideRecordedVideoThumb() {
        thumbnailView.image = defaultThumbImage
        secondaryThumbnailView.image = defaultThumbImage
        thumbnailNumberClips.text = ""
        secondaryThumbnailNumberClips.text = ""
        thumbnailInfoLabel.text = "Gallery".localize(inTable: "Settings")

        guard let sublayers = thumbnailView.layer.sublayers else {
            return
        }
        for layer in sublayers {
            layer.removeFromSuperlayer()
        }
        
        guard let secondarySublayers = secondaryThumbnailView.layer.sublayers else { return
        }
        for layer in secondarySublayers {
            layer.removeFromSuperlayer()
        }
    }

    func getThumbnailSize() -> CGFloat {
        return max(self.thumbnailView.frame.size.height, self.thumbnailView.frame.size.width)
    }

    func showNumberVideos(_ nClips: Int) {
        thumbnailNumberClips.text = "\(nClips)"
        thumbnailNumberClips.adjustsFontSizeToFitWidth = true
        
        secondaryThumbnailNumberClips.text = "\(nClips)"
        secondaryThumbnailNumberClips.adjustsFontSizeToFitWidth = true
    }

    func showFlashOn(_ on: Bool) {
        flashButton.isSelected = on
    }

    func showFlashSupported(_ state: Bool) {
        flashButton.isEnabled = state
    }

    func showFrontCameraSelected() {
        cameraRotationButton.isSelected = true
    }

    func showBackCameraSelected() {
        cameraRotationButton.isSelected = false
    }

    func resetView() {
        eventHandler?.resetRecorder()
    }

    func showFocusAtPoint(_ point: CGPoint) {

        focusImageView.center = point
        focusImageView.isHidden = false

        Utils().delay(0.5, closure: {
            self.focusImageView.isHidden = true
        })
    }

    func hidePrincipalViews() {
        fadeOutView([modeContainerView,
            upperContainerView])
    }

    func showPrincipalViews() {
        fadeInView([upperContainerView])
    }

    func hideSecondaryRecordViews() {
        fadeOutView([overlayGrid])
    }

    func showSecondaryRecordViews() {
        fadeInView([overlayGrid])
    }

    func showVideoSettingsConfig() {
        fadeInView([recordAreaContainerView])
        hideModeViewButton.isSelected = false
    }

    func hideVideoSettingsConfig() {
        fadeOutView([recordAreaContainerView])
        hideModeViewButton.isSelected = true
    }

	func hideGridView() {
		overlayGrid.isHidden = true
		gridButton.isSelected = false
	}

	func showGridView() {
		overlayGrid.isHidden = false
		gridButton.isSelected = true
	}

    func hideZoomView() {
        fadeOutView([zoomView])
        zoomButton.isSelected = false
        drawerButtonRight.isHidden = false
    }

    func showZoomView() {
        fadeInView([zoomView])
        drawerButtonRight.isHidden = true
        zoomButton.isSelected = true
    }

    func setBatteryIcon(_ images: IconsImage) {
        batteryButton.setImage(images.normal, for: UIControlState())
        batteryButton.setImage(images.pressed, for: .selected)
    }

    func setMemoryIcon(_ images: IconsImage) {
        storageButton.setImage(images.normal, for: UIControlState())
        storageButton.setImage(images.pressed, for: .selected)
    }

    func showBatteryView() {
//        self.cameraView.bringSubview(toFront: batteryView)
        fadeInView([batteryView])
        batteryButton.isSelected = true
    }

    func updateBatteryValues() {
        batteryView.updateValues()
    }

    func hideBatteryView() {
        fadeOutView([batteryView])
        batteryButton.isSelected = false
    }

    func updateSpaceOnDiskValues() {
        spaceOnDiskView.updateValues()
    }

    func showSpaceOnDisk() {
        fadeInView([spaceOnDiskView])
        storageButton.isSelected = true
    }

    func hideSpaceOnDiskView() {
        fadeOutView([spaceOnDiskView])
        storageButton.isSelected = false
    }

    func showISOConfigView() {
        fadeInView([isoConfigurationView])
        isoButton.isSelected = true
    }

    func hideISOConfigView() {
        fadeOutView([isoConfigurationView])
        isoButton.isSelected = false
    }

    func showWBConfigView() {
        fadeInView([wbConfigurationView])
        whiteBalanceButton.isSelected = true
    }

    func hideWBConfigView() {
        fadeOutView([wbConfigurationView])
        whiteBalanceButton.isSelected = false
    }

    func getMicValues() {
        audioLevelView.getAudioLevel()
    }

    func showMicLevelView() {
        audioLevelView.isHidden = false
    }

    func selectInputGainSliderView() {
        fadeInView([inputGainSlider])
        gainButton.isSelected = true
        drawerButtonRight.isHidden = true
    }

    func deselectInputGainSliderView() {
        fadeOutView([inputGainSlider])
        gainButton.isSelected = false
        drawerButtonRight.isHidden = false
    }

    func selectDeviceMicButton() {
        deviceMicButton.isSelected = true
    }

    func selectJackMicButton() {
        jackMicButton.isSelected = true
    }

    func deselectDeviceMicButton() {
        deviceMicButton.isSelected = false
    }

    func deselectJackMicButton() {
        jackMicButton.isSelected = false
    }

    func showJackMicButton() {
        jackMicButton.isHidden = true
    }

    func hideJackMicButton() {
        jackMicButton.isHidden = false
    }

    func showFrontMicButton() {
        deviceMicButton.isHidden = true
    }

    func hideFrontMicButton() {
        deviceMicButton.isHidden = false
    }

//    func setSelectedMicButton(_ state: Bool) {
//        micButton.isHidden = !state
//        micButton.isSelected = !state
//    }

    func showFocusView() {
        fadeInView([focusView])
        focusView.checkIfFocalLensIsEnabled()

        focusButton.isSelected = true
    }

    func hideFocusView() {
        fadeOutView([focusView])
        fadeOutView([focalLensSliderView])
        focusButton.isSelected = false
    }

    func showExposureModesView() {
        fadeInView([expositionModesView])
        expositionModesView.checkIfExposureManualSliderIsEnabled()

        exposureModesButton.isSelected = true
    }

    func hideExposureModesView() {
        fadeOutView([expositionModesView])
        fadeOutView([exposureConfigurationView])

        exposureModesButton.isSelected = false
    }

    func setResolutionToView(_ resolution: String) {
        resolutionsView.setResolutionAtInit(resolution)
    }

    func setResolutionIconImage(_ image: UIImage) {
        resolutionButton.setImage(image, for: UIControlState())
    }
    func setResolutionIconImagePressed(_ image: UIImage) {
        resolutionButton.setImage(image, for: .highlighted)
        resolutionButton.setImage(image, for: .selected)
    }

    func hideThumbnailButtonAndLabel() {
        fadeOutView([thumbnailViewParent])
    }

    func showThumbnailButtonAndLabel() {
        fadeInView([thumbnailViewParent])
    }

    func showRecordChronometerContainer() {
//        fadeInView([chronometerContainerView])
    }

    func hideRecordChronometerContainer() {
//        fadeOutView([chronometerContainerView])
    }

    func showModeViewAndButtonStateEnabled() {
        fadeInView([recordAreaContainerView])
    }

    func resetZoom() {
        zoomView.setDefaultZoom(1)
    }

    func hideModeViewAndButtonStateEnabled() {
        fadeOutView([recordAreaContainerView])
    }

    func showModeViewAndButtonStateDisabled() {
//        fadeInView([showModeViewButton])
    }

    func hideModeViewAndButtonStateDisabled() {
//        fadeOutView([showModeViewButton])
    }

    func showSecondaryRecordChronometerContainer() {
        fadeInView([secondaryChronometerContainer])
    }

    func hideSecondaryRecordChronometerContainer() {
        fadeOutView([secondaryChronometerContainer])
    }

    func setDefaultAllModes() {
//        zoomView.setZoomSliderValue(1)
//		zoomView.setDefaultZoom(1)
        isoConfigurationView.setAutoISO()
        wbConfigurationView.setAutoWB()
        focusView.setAutoFocus()
        expositionModesView.setAutoExposure()
		defaultModesButton.isSelected = true
    }

    func buttonsWithRecording(isEnabled: Bool) {
        resolutionButton.isEnabled = isEnabled
    }
	
	func hideSettingsContainerView() {
		fadeOutView([modeContainerView])
	}
	
	func showSettingsContainerView() {
		fadeInView([modeContainerView])
	}
	
	func hideUpperContainerView() {
		fadeOutView([upperContainerView])
	}
	
	func showUpperContainerView() {
		fadeInView([upperContainerView])
	}
	
	func hideRecordButton() {
		recordButton.isEnabled = false
		recordButton.fadeIn()
	}
	
	func showRecordButton() {
		recordButton.fadeOut()
		recordButton.isEnabled = true
	}
    
    func selectRecordButton() {
        self.recordButton.isSelected = true
    }
    
    func selectSecondaryRecordButton() {
        self.secondaryRecordButton.isSelected = true
        self.secondaryThumbnailView.isUserInteractionEnabled = false
    }
    
    func unselectRecordButton() {
        self.recordButton.isSelected = false
    }
    
    func unselectSecondaryRecordButton() {
        self.secondaryRecordButton.isSelected = false
         self.secondaryThumbnailView.isUserInteractionEnabled = true
    }
	
	func hideClipsRecordedView() {
		fadeOutView([thumbnailViewParent])
	}
	
	func showClipsRecordedView() {
		fadeInView([thumbnailViewParent])
	}
	
	func hideDrawerButton() {
		drawerButtonRight.isEnabled = false
		drawerButtonRight.fadeIn()
	}
	
	func showDrawerButton() {
		drawerButtonRight.fadeOut()
		drawerButtonRight.isEnabled = true
	}
	
	func showCameraSimpleView() {
		fadeInView([cameraSimpleView])
	}
	
	func hideCameraSimpleView() {
		fadeOutView([cameraSimpleView])
	}

    func startRecordingIndicatorBlink() {
        UIView.animate(
            withDuration: 1,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {
                self.recordingIndicator.alpha = 1.0
            }
        )
    }
	
    func stopRecordingIndicatorBlink() {
        recordingIndicator.layer.removeAllAnimations()
		secondaryRecordingIndicator.layer.removeAllAnimations()
        recordingIndicator.alpha = 0.0;
		secondaryRecordingIndicator.alpha = 0.0;
    }

    func startSecondaryRecordingIndicatorBlink() {
        UIView.animate(
            withDuration: 1,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: {
                self.secondaryRecordingIndicator.alpha = 1.0
            }
        )
    }
    
    func stopSecondaryRecordingIndicatorBlink() {
        secondaryRecordingIndicator.layer.removeAllAnimations()
        secondaryRecordingIndicator.alpha = 0.0;
    }
    
    func setAudioColor(_ color: UIColor) {
        audioLevelView.setBarColor(color)
    }
    
    func hideSecondaryRecordingIndicator() {
        secondaryRecordingIndicator.fadeIn()
        // secondaryRecordingIndicator.isEnabled = false
    }
    
    func showResolutionView() {
        resolutionButton.isSelected = true
        fadeInView([resolutionsView])
    }
    
    func hideResolutionView() {
        resolutionButton.isSelected = false
        fadeOutView([resolutionsView])
    }
    
}

// MARK: - BatteryRemaining delegate
extension RecordController:BatteryRemainingDelegate {
    func closeBatteryRemainingPushed() {
        eventHandler?.pushCloseBatteryButton()
    }
    func batteryValuesUpdated(_ value: Float) {
        eventHandler?.batteryValuesUpdate(value)
    }
}

// MARK: - SpaceOnDisk delegate
extension RecordController:SpaceOnDiskDelegate {
    func closeSpaceOnDiskPushed() {
        eventHandler?.pushCloseSpaceOnDiskButton()
    }
    func memoryValuesUpdated(_ value: Float) {
        eventHandler?.memoryValuesUpdate(value)
    }
}

// MARK: - AudioLevelBar delegate
extension RecordController:AudioLevelBarDelegate {
    func audioLevelChange(_ value: Float) {
        eventHandler?.audioLevelHasChanged(value)
    }
}

// MARK: - Exposition delegate
extension RecordController:ExpositionModesDelegate {
    func showExpositionSlider() {
        fadeInView([exposureConfigurationView])

        drawerButtonRight.isHidden = true
    }
    func hideExpositionSlider() {
        fadeOutView([exposureConfigurationView])

        drawerButtonRight.isHidden = false
    }
}

// MARK: - Focus delegate
extension RecordController: FocusDelegate {
    func showFocusLens() {
        fadeInView([focalLensSliderView])

        drawerButtonRight.isHidden = true
    }
    func hideFocusLens() {
        fadeOutView([focalLensSliderView])

        drawerButtonRight.isHidden = false
    }
}

// MARK: - Resolutions delegate
extension RecordController: ResolutionsSelectorDelegate {
    func resolutionToChangeReceived(_ resolution: String) {
        eventHandler?.saveResolutionToDefaults(resolution)
    }

    func removeResolutionsView() {
        eventHandler?.pushResolution()
    }
}
