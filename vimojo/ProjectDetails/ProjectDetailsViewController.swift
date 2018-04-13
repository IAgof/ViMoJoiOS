//
//  ProjectDetailsViewController.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class ProjectDetailsViewController: UIViewController, ProjectDetailsViewProtocol {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var frameRate: UILabel!
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var presenter: ProjectDetailsPresenterProtocol?
    var stackViewInitPoint: CGPoint!
    var formatText: (String, String) -> String {
        return { prefix, sufix in
            return prefix
                .addColons()
                .addSpace()
                .appending(sufix)
        }
    }
	override func viewDidLoad() {
        super.viewDidLoad()
        stackViewInitPoint = stackView.frame.origin
        // TODO: move formatting to presenter
        presenter?.loadValues(loaded: { (viewModel) in
            titleTextField.text = viewModel.title
            dateLabel.text = formatText("date_label".localized(.detailProject), viewModel.date)
            authorLabel.text = formatText("author_label".localized(.detailProject), viewModel.author)
            locationTextField.text = formatText("location_label".localized(.detailProject), viewModel.location)
            descriptionTextView.text = formatText("description_label".localized(.detailProject), viewModel.description)
            frameRate.text = formatText("frame_rate_label".localized(.detailProject), viewModel.frameRate.string)
            quality.text = formatText("quality_label".localized(.detailProject), viewModel.quality)
            duration.text = formatText("duration_label".localized(.detailProject), viewModel.duration.string)
        })
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProjectDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        addObserverToShowAndHideKeyboard()
        descriptionTextView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        presenter?.cancel()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        presenter?.saveValues(title: titleTextField.text,
                              location: locationTextField.text,
                              description: descriptionTextView.text)
    }
    @IBAction func locationButtonTapped(_ sender: Any) {
        presenter?.getLocation(location: { (location) in
            self.locationTextField.text = location
        })
    }
    @IBAction func goToSelectKindOfProject(_ sender: Any) {
        presenter?.goToSelectKindOfProject()
    }
}
extension ProjectDetailsViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        stackView.moveTo(y: -65)
        return true
    }
}
// MARK:  Keyboard UIcontrol
extension ProjectDetailsViewController {
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func addObserverToShowAndHideKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProjectDetailsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func keyboardWillHide(_ notification: Notification) {
        stackView.moveTo(point: stackViewInitPoint)
    }
}
