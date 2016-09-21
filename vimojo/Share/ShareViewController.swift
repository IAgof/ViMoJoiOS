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

class ShareViewController: ViMoJoController,ShareInterface ,PlayerViewSetter,
UINavigationBarDelegate ,
UITableViewDelegate, UITableViewDataSource,
GIDSignInUIDelegate,GIDSignInDelegate{
    
    //MARK: - VIPER
    var eventHandler: SharePresenterInterface?
    
    //MARK: - Variables and Constants
    var titleBar = "Share video"
    var titleBackButtonBar = "Back"
    
    let reuseIdentifierCell = "shareCell"
    let shareNibName = "ShareCell"
    var listImages = Array<UIImage>()
    var listImagesPressed = Array<UIImage>()
    var listTitles = Array<String>()
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
    
    func setTitleList(titleList: Array<String>) {
        self.listTitles = titleList
    }
    
    func setImageList(imageList: Array<UIImage>) {
        self.listImages = imageList
    }
    func setImagePressedList(imageList: Array<UIImage>) {
        self.listImagesPressed = imageList
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

    //MARK: - UITableView Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return listTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifierCell) as! ShareCell
        
        cell.shareTitle!.text = listTitles[indexPath.item]
        cell.shareImage!.image = listImages[indexPath.item]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShareCell
        
        cell.shareTitle!.textColor = VIMOJO_GREEN_UICOLOR
        cell.shareImage!.image = listImagesPressed[indexPath.item]
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ShareCell
        
        cell.shareTitle!.textColor = UIColor.darkGrayColor()
        cell.shareImage!.image = listImages[indexPath.item]
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = listImages[indexPath.item].size.height
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
        
        print(self.playerView.subviews)
        
        print("You selected in position #\(indexPath.item)\n filter name: \(listTitles[indexPath.item])")
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        eventHandler?.pushShare(listTitles[indexPath.item])
    }
    
    //MARK: - Google methods
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        
        self.presentViewController(viewController, animated: false, completion: nil)
        
        Utils().debugLog("SignIn")
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        Utils().debugLog("SignIn Dissmiss")
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        Utils().debugLog("Google Sign In get user token")
        
        //Error control
        if (error == nil) {
            token = user.authentication.accessToken
            
            Utils().debugLog("Google Sign In get user token: \(token))")
            
            eventHandler!.postToYoutube(token)
        } else {
            Utils().debugLog("\(error.localizedDescription)")
        }
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
