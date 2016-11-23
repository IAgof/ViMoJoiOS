//
//  EditingRoomViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import VideonaProject

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
        self.navigationController?.isNavigationBarHidden = true
        
        forcePortrait = true
        
        eventHandler?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    //MARK: - Button Actions
    @IBAction func pushGoToSettings(_ sender: AnyObject) {
        eventHandler?.pushSettings()
    }

    @IBAction func pushBackButton(_ sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    @IBAction func pushGoToEditor(_ sender: AnyObject) {
        eventHandler?.pushEditor()
    }
    
    @IBAction func pushGoToMusic(_ sender: AnyObject) {
        eventHandler?.pushMusic()
    }
    
    @IBAction func pushGoToShare(_ sender: AnyObject) {
        eventHandler?.pushShare()
    }

    
    //MARK: - Interface
    func deselectAllButtons() {
        self.editorButton.isSelected = false
        self.musicButton.isSelected = false
        self.shareButton.isSelected = false
    }
    
    func selectEditorButton() {
        self.editorButton.isSelected = true
    }
    
    func selectMusicButton() {
        self.musicButton.isSelected = true
    }
    
    func selectShareButton() {
        self.shareButton.isSelected = true
    }
    
    func createAlertWaitToExport(){
        let title = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_TITLE)
        let message = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_DESCRIPTION)
        
        alertController = UIAlertController(title:title,message:message,preferredStyle: .alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        
        activityIndicator.center = CGPoint(x: 130.5, y: 75.5);
        activityIndicator.startAnimating()
        
        alertController?.view.addSubview(activityIndicator)
        self.present(alertController!, animated: false, completion:{})
    }
    
    func dissmissAlertWaitToExport(_ completion:@escaping ()->Void){
        alertController?.dismiss(animated: true, completion: {
            print("can go to next screen")
            completion()
        })
    }
}
