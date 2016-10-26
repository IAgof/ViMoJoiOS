//
//  ShareViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Foundation
import VideonaPlayer
import GoogleSignIn

class ShareViewController: ViMoJoController,PlayerViewSetter,
UINavigationBarDelegate ,
UITableViewDelegate, UITableViewDataSource
,FullScreenWireframeDelegate{
    
    //MARK: - VIPER
    var eventHandler: SharePresenterInterface?
    
    //MARK: - Variables and Constants
    var titleBar = "Share video"
    var titleBackButtonBar = "Back"
    
    let reuseIdentifierCell = "shareCell"
    let shareNibName = "ShareCell"
    var displayShareObjects:[ShareViewModel] = []
    var token:String!

    var exportPath: String? {
        didSet {
            eventHandler?.setVideoExportedPath(exportPath!)
        }
    }
    
    var numberOfClips:Int? {
        didSet {
            eventHandler?.setNumberOfClipsToExport(numberOfClips!)
        }
    }
    
    //MARK: - Outlets
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var settingsNavBar: UINavigationItem!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var shareGenericButton: UIButton!

    
    override func viewDidLoad() {

        super.viewDidLoad()
        print("ViewDid Load")

        eventHandler?.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        eventHandler?.viewWillDisappear()
    }
    
    //MARK: - View Init
    func createShareInterface(){
        let nib = UINib.init(nibName: shareNibName, bundle: nil)
        shareTableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifierCell)
        
        //Google Sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self        
    }

    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func setNavBarTitle(title:String){
        //        settingsNavBar.title = title
    }
    
    func removeSeparatorTable() {
        shareTableView.separatorStyle = .None
    }
    
    @IBAction func pushBackBarButton(sender: AnyObject) {
        eventHandler?.pushBack()
    }
    @IBAction func pushExpandButton(sender: AnyObject) {
        eventHandler?.expandPlayer()
    }

    @IBAction func pushGenericShare(sender: AnyObject) {
        eventHandler?.pushGenericShare()
    }
    
    //MARK: - UITableView Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return displayShareObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierCell) as! ShareCell
        
        cell.shareTitle!.text = displayShareObjects[indexPath.item].title
        cell.shareImage!.image = displayShareObjects[indexPath.item].icon
        
        return cell
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShareCell
        
        cell.shareTitle!.textColor = VIMOJO_GREEN_UICOLOR
        cell.shareImage!.image = displayShareObjects[indexPath.item].iconPressed
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShareCell
        
        cell.shareTitle!.textColor = UIColor.darkGrayColor()
        cell.shareImage!.image = displayShareObjects[indexPath.item].icon
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = displayShareObjects[indexPath.item].icon.size.height
        Utils.sharedInstance.debugLog("Height for social = \(height)")
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            return CGFloat(90)
        }else{
            return CGFloat(50)
        }
    }
    
    //MARK: - UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("You selected in position #\(indexPath.item)\n filter name: \(displayShareObjects[indexPath.item])")
        
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        eventHandler?.pushShare(indexPath)
    }
    
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension ShareViewController:SharePresenterDelegate{
    //Presenter delegate
    func showShareGeneric(moviePath:String) {
        
        let movie:NSURL = NSURL.fileURLWithPath(moviePath)
        
        let objectsToShare = [movie] //comment!, imageData!, myWebsite!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.setValue("Video", forKey: "subject")
        
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypeOpenInIBooks, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint]
        
        
        if (activityVC.popoverPresentationController != nil) {
            activityVC.popoverPresentationController!.sourceView = shareGenericButton
        }
        
        self.presentViewController(activityVC, animated: false, completion: nil)
    }
    
    func setShareViewObjectsList(viewObjects: [ShareViewModel]){
        self.displayShareObjects = viewObjects
        shareTableView.reloadData()
    }
}
