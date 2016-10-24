//
//  AddTextViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer
import AVFoundation
import VideonaProject

class AddTextViewController: ViMoJoController {
    var eventHandler: AddTextPresenterInterface?
    var wireframe:AddTextWireframe?
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

    
    @IBAction func topTextButtonPushed(sender: AnyObject) {
        eventHandler?.topButtonPushed()
    }
    
    @IBAction func midTextButtonPushed(sender: AnyObject) {
        eventHandler?.midButtonPushed()
    }
    
    @IBAction func bottomTextButtonPushed(sender: AnyObject) {
        eventHandler?.bottomButtonPushed()
    }
        
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }
    
    @IBAction func acceptButtonPushed(sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
    
    @IBAction func pushBackBarButton(sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
        
        addTextTextView.textContainer.maximumNumberOfLines = MAX_LINES
        addTextTextView.textContainer.lineBreakMode = .ByWordWrapping
        
        addTextTextView.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTextViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        addObserverToShowAndHideKeyboard()
        addBorderToTextView()
        addDoneButtonOnKeyboard()
    }
    
    func addObserverToShowAndHideKeyboard(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddTextViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddTextViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func addBorderToTextView(){
        addTextTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        addTextTextView.layer.borderWidth = 2
        addTextTextView.layer.cornerRadius = 2
    }
}

extension AddTextViewController:AddTextPresenterDelegate{
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
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
    
    func setPlayerToSeekTime(time: Float) {
        playerHandler?.seekToTime(time)
    }
    
    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }
    
    func updatePlayerOnView(composition: VideoComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }
    
    func setTextToEditTextField(text: String) {
        self.addTextTextView.text = text
    }
        
    func setSyncLayerToPlayer(layer: CALayer) {
        playerHandler?.setAVSyncLayer(layer)
    }
    
    func setSelectedTopButton(state: Bool) {
        topTextConfigButton.selected = state
    }
    
    func setSelectedMidButton(state: Bool) {
        midTextConfigButton.selected = state
    }
    
    func setSelectedBottomButton(state: Bool) {
        bottomTextConfigButton.selected = state
    }
}
extension AddTextViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension AddTextViewController:UITextViewDelegate{
    func textViewDidChange(textView: UITextView) {
        guard let text = addTextTextView.text else{return}

        eventHandler?.textHasChanged(text)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        guard let currentString: NSString = textView.text else{return false}
        
        
        if (checkIfHasLineBreak(currentString as String) && text == "\n"){
            
            return false
        }else if range.length == 0{
            let replacementString = addLineBreakIfNeccesary(currentString as String) as NSString
            
            textView.text = replacementString as String
            
            let shouldChange = ((replacementString.length <= limitLength))
            print("Should change text in textView: \(shouldChange)")
            
            return shouldChange
        }else{
            return true
        }
    }
    
    func checkIfHasLineBreak(text:String) -> Bool {
        if(((text as String).rangeOfString("\n")) != nil){
            return true
        }else
        {
            return false
        }
    }
    
    func addLineBreakIfNeccesary(text:String)->String{
        if ((text.characters.count == maxCharForLine) && !checkIfHasLineBreak(text) ) {
            let nextLine = "\n"
            
            let preText = text.substringWithRange(Range<String.Index>(start: text.startIndex, end: text.startIndex.advancedBy(maxCharForLine)))
            let postText = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(maxCharForLine), end: text.endIndex))
            
            if postText.characters.count >  maxCharForLine{
                return text
            }
            
            let finalText = preText + nextLine + postText
            
            return finalText
        }
        
        guard let linebreakPosition = text.rangeOfString("\n") else{
            return text
        }
        let nextLine = "\n"
        
        let preText = text.substringWithRange(Range<String.Index>(start: text.startIndex, end: linebreakPosition.startIndex))
        var postText = text.substringWithRange(Range<String.Index>(start: linebreakPosition.endIndex, end: text.endIndex))
        
        if postText.characters.count >  maxCharForLine{
            var postText = postText.substringWithRange(Range<String.Index>(start: postText.startIndex, end: postText.startIndex.advancedBy(maxCharForLine)))
            
            return (preText + nextLine + postText)
        }
        
        return text
    }
}

//MARK: Keyboard handler
extension AddTextViewController{
    func keyboardWillShow(notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= addTextTextView.frame.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y == (-addTextTextView.frame.height){
            self.view.frame.origin.y += addTextTextView.frame.height
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(AddTextViewController.doneButtonAction))
        done.tintColor = UIColor.whiteColor()
        
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        
        self.addTextTextView.inputAccessoryView = doneToolbar
        self.addTextTextView.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        view.endEditing(true)
    }
}