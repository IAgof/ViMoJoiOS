//
//  ProjectDetailsViewController.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit

class ProjectDetailsViewController: UIViewController, ProjectDetailsViewProtocol {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var projectTypesButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var frameRate: UILabel!
    @IBOutlet weak var quality: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    var presenter: ProjectDetailsPresenterProtocol?
    var stackViewInitPoint: CGPoint!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        stackViewInitPoint = stackView.frame.origin
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProjectDetailsViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        addObserverToShowAndHideKeyboard()
        descriptionTextView.delegate = self
        presenter?.loadValues(loaded: { (viewModel) in
            titleTextField.text = viewModel.title
            locationTextField.text = viewModel.location
            descriptionTextView.text = viewModel.description
            frameRate.text = viewModel.frameRate
            quality.text = viewModel.quality
            duration.text = viewModel.duration
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        presenter?.loadValues(loaded: { (viewModel) in
            projectTypesButton.setAttributedTitle(viewModel.kindOfProjectsSelected, for: .normal)
        })
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
        saveValues()
    }
    @IBAction func locationButtonTapped(_ sender: Any) {
        presenter?.getLocation(location: { (location) in
            self.locationTextField.text = location
        })
    }
    @IBAction func goToSelectKindOfProject(_ sender: Any) {
        presenter?.goToSelectKindOfProject()
    }
    
    func saveValues() {
        presenter?.saveValues(title: titleTextField.text,
                              location: locationTextField.text,
                              description: descriptionTextView.text)
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
