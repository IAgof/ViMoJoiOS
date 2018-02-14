//
//  AddTextViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation
import VideonaProject

class AddTextViewController: ViMoJoController {
    var eventHandler: AddTextPresenterInterface?
    var wireframe: AddTextWireframe?
    var playerHandler: PlayerPresenterInterface?

    let limitLength = 60
    let MAX_LINES = 2
    var maxCharForLine = 30

    @IBOutlet weak var topTextConfigButton: UIButton!
    @IBOutlet weak var midTextConfigButton: UIButton!
    @IBOutlet weak var bottomTextConfigButton: UIButton!
    @IBOutlet weak var addTextTextView: UITextView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    override var forcePortrait: Bool {
        return true
    }

    @IBAction func topTextButtonPushed(_ sender: AnyObject) {
        eventHandler?.topButtonPushed()
    }

    @IBAction func midTextButtonPushed(_ sender: AnyObject) {
        eventHandler?.midButtonPushed()
    }

    @IBAction func bottomTextButtonPushed(_ sender: AnyObject) {
        eventHandler?.bottomButtonPushed()
    }

    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }

    @IBAction func acceptButtonPushed(_ sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
	
	@IBAction func pushExpandButton(_ sender: AnyObject) {
		eventHandler?.expandPlayer()
	}
	
    override func pushBack() {
        eventHandler?.pushBack()
    }

    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
		
		UIApplication.shared.statusBarView?.backgroundColor = configuration.mainColor

        addTextTextView.textContainer.maximumNumberOfLines = MAX_LINES
        addTextTextView.textContainer.lineBreakMode = .byWordWrapping

        addTextTextView.delegate = self

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTextViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        addObserverToShowAndHideKeyboard()
        addBorderToTextView()
        addDoneButtonOnKeyboard()

        playerHandler?.timeLabels(isHidden: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        setPlayerPlayButtonState(state: false)
        playerHandler?.timeLabels(isHidden: false)
        setViewOnZero()
		configureNavigationBarVissible()
        self.view.frame.origin.y = 0
        
    }

    override func viewWillAppear(_ animated: Bool) {
		wireframe?.presentPlayerInterface()
		configureNavigationBarHidden()
    }

    func addObserverToShowAndHideKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddTextViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddTextViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func addBorderToTextView() {
        addTextTextView.layer.borderColor = UIColor.lightGray.cgColor
        addTextTextView.layer.borderWidth = 2
        addTextTextView.layer.cornerRadius = 2
    }
}

extension AddTextViewController:AddTextPresenterDelegate {
    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }

    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        playerHandler?.layoutSubViews()
    }

    func acceptFinished() {
        wireframe?.goPrevController()
    }

    func pushBackFinished() {
        wireframe?.goPrevController()
    }

    func expandPlayerToView() {
        wireframe?.presentExpandPlayer()
    }

    func setPlayerToSeekTime(_ time: Float) {
        playerHandler?.seekToTime(time)
    }

    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }

    func updatePlayerOnView(_ composition: VideoComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }

    func setTextToEditTextField(_ text: String) {
        self.addTextTextView.text = text
    }

    func setSyncLayerToPlayer(_ layer: CALayer) {
        playerHandler?.setAVSyncLayer(layer)
    }

    func setSelectedTopButton(_ state: Bool) {
        topTextConfigButton.isSelected = state
    }

    func setSelectedMidButton(_ state: Bool) {
        midTextConfigButton.isSelected = state
    }

    func setSelectedBottomButton(_ state: Bool) {
        bottomTextConfigButton.isSelected = state
    }
}
extension AddTextViewController:PlayerViewSetter {
    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension AddTextViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = addTextTextView.text else {return}

        eventHandler?.textHasChanged(text)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentString: NSString = textView.text as NSString? else {return false}

        if (checkIfHasLineBreak(currentString as String) && text == "\n") {

            return false
        } else if range.length == 0 {
            let replacementString = addLineBreakIfNeccesary(currentString as String) as NSString

            textView.text = replacementString as String

            let shouldChange = ((replacementString.length <= limitLength))
            print("Should change text in textView: \(shouldChange)")

            return shouldChange
        } else {
            return true
        }
    }

    func checkIfHasLineBreak(_ text: String) -> Bool {
        if(((text as String).range(of: "\n")) != nil) {
            return true
        } else {
            return false
        }
    }

    func addLineBreakIfNeccesary(_ text: String) -> String {
        if ((text.characters.count == maxCharForLine) && !checkIfHasLineBreak(text) ) {
            let nextLine = "\n"

            let preText = text.substring(with: (text.startIndex ..< text.characters.index(text.startIndex, offsetBy: maxCharForLine)))
            let postText = text.substring(with: (text.characters.index(text.startIndex, offsetBy: maxCharForLine) ..< text.endIndex))

            if postText.characters.count >  maxCharForLine {
                return text
            }

            let finalText = preText + nextLine + postText

            return finalText
        }

        guard let linebreakPosition = text.range(of: "\n") else {
            return text
        }
        let nextLine = "\n"

        let preText = text.substring(with: (text.startIndex ..< linebreakPosition.lowerBound))
        let postText = text.substring(with: (linebreakPosition.upperBound ..< text.endIndex))

        if postText.characters.count >  maxCharForLine {
            let postText = postText.substring(with: (postText.startIndex ..< postText.characters.index(postText.startIndex, offsetBy: maxCharForLine)))

            return (preText + nextLine + postText)
        }

        return text
    }
}

// MARK: Keyboard handler
extension AddTextViewController {
    func keyboardWillShow(_ notification: Notification) {
        guard let x = self.navigationController?.view.frame.origin.x,
           let y = self.navigationController?.view.frame.origin.y else { return }
        let newPoint = CGPoint(x: x,
                               y: y - (addTextTextView.frame.height / 2))
        moveViewTo(point: newPoint)
    }

    fileprivate func setViewOnZero() {
        moveViewTo(point: CGPoint.zero)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        setViewOnZero()
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        doneToolbar.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(with: "Done", target: self,
                                                    action: #selector(AddTextViewController.doneButtonAction))
        done.tintColor = UIColor.white
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()

        self.addTextTextView.inputAccessoryView = doneToolbar
        self.addTextTextView.inputAccessoryView = doneToolbar

    }

    func doneButtonAction() {
        view.endEditing(true)
    }
}

extension AddTextViewController:PlayerViewFinishedDelegate {
    func playerHasLoaded() {
        setPlayerPlayButtonState(state: true)
    }

    func playerPause() {
        setPlayerPlayButtonState(state: true)
    }

    func setPlayerPlayButtonState(state: Bool) {
        for view in playerView.subviews {
            if let player =  view as? PlayerView {
                if state {
                    player.sendSubview(toBack: player.playOrPauseButton)
                } else {
                    player.bringSubview(toFront: player.playOrPauseButton)
                }
            }
        }
    }

    func playerStartsToPlay() {

    }

    func playerSeeksTo(_ value: Float) {

    }
}
extension UIBarButtonItem {
    public convenience init(with text: String, target: Any, action: Selector) {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: button)
    }
}
