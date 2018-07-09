//
//  RecordingCameraConfigurationViewController.swift
//  vimojo
//
//  Created Jesus Huerta on 19/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit

class RecordingCameraConfigurationViewController: UIViewController, RecordingCameraConfigurationViewProtocol {

	// MARK: Outlets
	@IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cameraProButton: UIButton!
    @IBOutlet weak var cameraBasicButton: UIButton!
    @IBOutlet weak var sevenTwentyResolutionButton: UIButton!
    @IBOutlet weak var oneEightyResolutionButton: UIButton!
	@IBOutlet weak var fourKResolutionButton: UIButton!
	@IBOutlet weak var twentyFivefpsButton: UIButton!
    @IBOutlet weak var thirtyFpsButton: UIButton!
	@IBOutlet weak var sixtyFpsButton: UIButton!
    @IBOutlet weak var sixteenMbpsButton: UIButton!
    @IBOutlet weak var thirtyTwoMbpsButton: UIButton!
    @IBOutlet weak var frontRearSegControl: UISegmentedControl!

    // MARK: SSRadioControllers
    var cameraSSRBController: SSRadioButtonsController = SSRadioButtonsController()
    var resolutionSSRBController: SSRadioButtonsController = SSRadioButtonsController()
    var fpsSSRBController: SSRadioButtonsController = SSRadioButtonsController()
    var mbpsSSRBController: SSRadioButtonsController = SSRadioButtonsController()
    
    var cameraButtons: [UIButton] = []
    var resolutionButtons: [UIButton] = []
    var fpsButtons: [UIButton] = []
    var mbpsButtons: [UIButton] = []
    
    var presenter: RecordingCameraConfigurationPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtonsArray()
        setupSSControllers()
		okButton.setTitleColor(UIColor.black, for: UIControlState.normal)
		configureCameraResolutions()
        presenter?.viewDidLoad()
    }
	override open var shouldAutorotate: Bool {
		return false
	}
    func setupSSControllers() {
        cameraSSRBController.setButtonsArray(cameraButtons)
        resolutionSSRBController.setButtonsArray(resolutionButtons)
        fpsSSRBController.setButtonsArray(fpsButtons)
        mbpsSSRBController.setButtonsArray(mbpsButtons)
    }
    func setUpButtonsArray() {
        cameraButtons = [ cameraProButton, cameraBasicButton ]
        fpsButtons = [twentyFivefpsButton, thirtyFpsButton, sixtyFpsButton]
        mbpsButtons = [sixteenMbpsButton, thirtyTwoMbpsButton]
        resolutionButtons =
            [sevenTwentyResolutionButton
				, oneEightyResolutionButton, fourKResolutionButton]
    }
    // MARK: Actions
    @IBAction func cameraProPush(_ sender: Any)
    { presenter?.actionPush(with: .camera(.cameraPro)) }
    @IBAction func cameraBasicPush(_ sender: Any)
    { presenter?.actionPush(with: .camera(.cameraBasic)) }
    @IBAction func sevenTwentyResolutioPush(_ sender: Any)
    { presenter?.actionPush(with: .resolution(.sevenHundred)) }
    @IBAction func oneEightyResolutionPush(_ sender: Any)
    { presenter?.actionPush(with: .resolution(.oneThousand)) }
	@IBAction func fourKResolutionPush(_ sender: Any)
	{ presenter?.actionPush(with: .resolution(.fourThousand)) }
    @IBAction func twentyFivefpsPush(_ sender: Any)
    { presenter?.actionPush(with: .fps(.twentyFive)) }
    @IBAction func thirtyFpsPush(_ sender: Any)
    { presenter?.actionPush(with: .fps(.thirty)) }
	@IBAction func sixtyFpsPush(_ sender: Any)
	{ presenter?.actionPush(with: .fps(.sixty)) }
    @IBAction func sixteenMbpsButton(_ sender: Any)
    { presenter?.actionPush(with: .mbps(.sixteenMB)) }
    @IBAction func thirtyTwoMbpsPush(_ sender: Any)
    { presenter?.actionPush(with: .mbps(.thirtyTwoMB)) }
    @IBAction func okPush(_ sender: Any)
    { self.navigationController?.popViewController() }
    
    @IBAction func frontRearSegControlChanged(_ sender: UISegmentedControl) {
        presenter?.cameraSelected(cameraIndex: sender.selectedSegmentIndex)
    }
    
    func setDefaultValues(loadedValues: RecordingCameraValues) {
        cameraSSRBController.pressed(cameraButtons[loadedValues.0.rawValue])
        resolutionSSRBController.pressed(resolutionButtons[loadedValues.1.rawValue])
        fpsSSRBController.pressed(fpsButtons[loadedValues.2.rawValue])
        mbpsSSRBController.pressed(mbpsButtons[loadedValues.3.rawValue])
    }
    func reloadCamera() {
        configureCameraResolutions()
    }
	// All resolutions in back camera supports 720 and 1080p. Only some supports 4k
	func configureCameraResolutions() {
		let deviceModel = UIDevice.current.modelName
		switch CamSettings.cameraPosition {
		case .back:
			oneEightyResolutionButton.isEnabled = true
			oneEightyResolutionButton.isHidden = false
			if (deviceModel == "iPhone SE" ||
				deviceModel == "iPhone 6" ||
				deviceModel == "iPhone 6 Plus" ||
				deviceModel == "iPhone 6s" ||
				deviceModel == "iPhone 6s Plus" ||
				deviceModel == "iPhone 7" ||
				deviceModel == "iPhone 7 Plus" ||
				deviceModel == "iPhone 8" ||
				deviceModel == "iPhone 8 Plus" ||
				deviceModel == "iPhone X") {
				fourKResolutionButton.isEnabled = true
				fourKResolutionButton.isHidden = false
			} else {
                fourKResolutionButton.isEnabled = false
                fourKResolutionButton.isHidden = true
			}
		case .front:
			fourKResolutionButton.isEnabled = false
			fourKResolutionButton.isHidden = true
			if (deviceModel == "iPhone 7" ||
				deviceModel == "iPhone 7 Plus" ||
				deviceModel == "iPhone 8" ||
				deviceModel == "iPhone 8 Plus" ||
				deviceModel == "iPhone X" ||
				deviceModel == "iPad Pro") {
				oneEightyResolutionButton.isEnabled = true
				oneEightyResolutionButton.isHidden = false
			} else {
				oneEightyResolutionButton.isEnabled = false
				oneEightyResolutionButton.isHidden = true
			}
		}
	}
}
