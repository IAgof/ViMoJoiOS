//
//  DetailProjectViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class DetailProjectViewController: ViMoJoController {
    var eventHandler: DetailProjectPresenterInterface?

    // MARK: Outlets
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var filesizeLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var bitrateLabel: UILabel!
    @IBOutlet weak var frameRateLabel: UILabel!
    @IBOutlet weak var cancelAndAcceptViewContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        projectNameTextField.delegate = self
        configureNavigationBarWithBackButton()
        eventHandler?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDissappear()
    }

    // MARK: Actions
    @IBAction func pushAcceptButton(_ sender: Any) {
        eventHandler?.accept()
    }

    @IBAction func pushCancelButton(_ sender: Any) {
        eventHandler?.cancel()
    }
    @IBAction func projectNameEditingChanged(_ sender: Any) {
        guard let text = projectNameTextField.text else {return}
        eventHandler?.projectNameChange(name: text)
    }
    override func pushBack() {
        eventHandler?.pushBack()
    }
}

extension DetailProjectViewController:DetailProjectPresenterDelegate {
    func displayParams(viewModel: DetailProjectViewModel) {
        thumbImageView.image = viewModel.thumbImage
        projectNameTextField.text = viewModel.projectName
        durationLabel.text = viewModel.duration
        filesizeLabel.text = viewModel.size
        qualityLabel.text = viewModel.quality
        formatLabel.text = viewModel.format
        bitrateLabel.text = viewModel.bitrate
        frameRateLabel.text = viewModel.frameRate
    }

    func setButtonsContainerIsHidden(isHidden: Bool) {
        cancelAndAcceptViewContainer.isHidden = isHidden
    }
}

extension DetailProjectViewController:UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cancelAndAcceptViewContainer.isHidden = false
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
