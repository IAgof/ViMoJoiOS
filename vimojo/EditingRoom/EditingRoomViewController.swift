//
//  EditingRoomViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

class EditingRoomViewController: ViMoJoController,EditingRoomViewInterface,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK: - Variables VIPER
    var eventHandler: EditingRoomPresenterInterface?
    
    //MARK: - Outlets
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editorButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var containerView: UIView!

    //MARK: - Variables
    var alertController:UIAlertController?

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        
        forcePortrait = true
        
        eventHandler?.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.viewWillAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    //MARK: - Button Actions
    @IBAction func pushGoToSettings(sender: AnyObject) {
        eventHandler?.pushSettings()
    }

    @IBAction func pushBackButton(sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    @IBAction func pushGoToEditor(sender: AnyObject) {
        eventHandler?.pushEditor()
    }
    
    @IBAction func pushGoToMusic(sender: AnyObject) {
        eventHandler?.pushMusic()
    }
    
    @IBAction func pushGoToShare(sender: AnyObject) {
        eventHandler?.pushShare()
    }

    
    //MARK: - Interface
    func deselectAllButtons() {
        self.editorButton.selected = false
        self.musicButton.selected = false
        self.shareButton.selected = false
    }
    
    func selectEditorButton() {
        self.editorButton.selected = true
    }
    
    func selectMusicButton() {
        self.musicButton.selected = true
    }
    
    func selectShareButton() {
        self.shareButton.selected = true
    }
    
    func createAlertWaitToExport(){
        let title = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_TITLE)
        let message = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_DESCRIPTION)
        
        alertController = UIAlertController(title:title,message:message,preferredStyle: .Alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        
        activityIndicator.center = CGPointMake(130.5, 75.5);
        activityIndicator.startAnimating()
        
        alertController?.view.addSubview(activityIndicator)
        self.presentViewController(alertController!, animated: false, completion:{})
    }
    
    func dissmissAlertWaitToExport(completion:()->Void){
        alertController?.dismissViewControllerAnimated(true, completion: {
            print("can go to next screen")
            completion()
        })
    }
}
