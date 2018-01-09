//
//  ShareViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Foundation
import VideonaProject
import GoogleSignIn

class ShareViewController: EditingRoomItemController, PlayerViewSetter,
UINavigationBarDelegate ,
UITableViewDelegate, UITableViewDataSource, FullScreenWireframeDelegate {

    // MARK: - VIPER
    var eventHandler: SharePresenterInterface?

    // MARK: - Variables and Constants
    var titleBar = "Share video"
    var titleBackButtonBar = "Back"

    let reuseIdentifierCell = "shareCell"
    let shareNibName = "ShareCell"
    var displayShareObjects: [ShareViewModel] = []
    var token: String!

    var exportPath: String? {
        didSet {
            if let url = URL(string: exportPath!) {
                eventHandler?.setVideoExportedPath(url)
            }
        }
    }

    var numberOfClips: Int? {
        didSet {
            eventHandler?.setNumberOfClipsToExport(numberOfClips!)
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var shareTableView: UITableView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var shareGenericButton: UIButton!

    var alertController: UIAlertController?

    override func viewDidLoad() {

        super.viewDidLoad()
        print("ViewDid Load")
		UIApplication.shared.statusBarView?.backgroundColor = configuration.mainColor
        eventHandler?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        eventHandler?.viewDidAppear()
		self.tabBarController?.tabBar.isHidden = true
		configureNavigationBarHidden()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
		configureNavigationBarVissible()
        eventHandler?.viewWillDisappear()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithDrawerAndOptions()
        self.shareGenericButton.isHidden = true
        self.expandPlayerButton.isHidden = true
    }

    // MARK: - View Init
    func createShareInterface() {
        let nib = UINib.init(nibName: shareNibName, bundle: nil)
        shareTableView.register(nib, forCellReuseIdentifier: reuseIdentifierCell)

        //Google Sign in
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }

    func removeSeparatorTable() {
        shareTableView.separatorStyle = .none
    }

    @IBAction func pushBackBarButton(_ sender: AnyObject) {
        eventHandler?.pushBack()
    }
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }

    @IBAction func pushGenericShare(_ sender: AnyObject) {
        eventHandler?.pushGenericShare()
    }

    override func pushOptions() {
        eventHandler?.pushOptions()
    }

    // MARK: - UITableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return displayShareObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get a reference to our storyboard cell
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell) as! ShareCell

        cell.shareTitle!.text = displayShareObjects[indexPath.item].title
        cell.shareImage!.image = displayShareObjects[indexPath.item].icon

        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ShareCell

        cell.shareTitle!.textColor = configuration.mainColor
        cell.shareImage!.image = displayShareObjects[indexPath.item].iconPressed
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ShareCell

        cell.shareTitle!.textColor = UIColor.darkGray
        cell.shareImage!.image = displayShareObjects[indexPath.item].icon

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = displayShareObjects[indexPath.item].icon.size.height
        Utils().debugLog("Height for social = \(height)")
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGFloat(90)
        } else {
            return CGFloat(50)
        }
    }

    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("You selected in position #\(indexPath.item)\n filter name: \(displayShareObjects[indexPath.item])")

        tableView.cellForRow(at: indexPath)?.isSelected = false
        eventHandler?.pushShare(indexPath)
    }

    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }

    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension ShareViewController:SharePresenterDelegate {

    //Presenter delegate

	func createAlertWaitToExport(cancelAction: @escaping () -> Void) {
        let title = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_TITLE)
        let message = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_DESCRIPTION)
        let currentTimeExportedMessage = Utils().getStringByKeyFromSettings(RecordConstants().WAIT_EXPORTING)
        self.eventHandler?.getSessionExportProgress({
            progress in
            self.alertController?.message = currentTimeExportedMessage + " \(progress)%"
        })
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)

        guard let alertC = alertController else {return}
        alertC.setTintColor()

		// TODO: Change text
		alertController?.addAction(UIAlertAction(title: "Cancel",
												 style: .default, handler: { (_) in
													cancelAction()
		}))
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

        activityIndicator.center = CGPoint(x: 130.5, y: 67)
        activityIndicator.startAnimating()

        alertC.view.addSubview(activityIndicator)

        self.present(alertC, animated: true, completion: nil)
    }

    func createAlertExportFailed() {
        let title = ShareConstants.EXPORT_FAILED_TITLE
        let message = ShareConstants.EXPORT_FAILED_MESSAGE

        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)

        guard let alertC = alertController else {return}
        alertC.setTintColor()

        let action = UIAlertAction(title: ShareConstants.OK,
                                   style: .default,
                                   handler: {
                                    _ in
                                    self.eventHandler?.exportFailOkPushed()
        })

        alertC.addAction(action)
        self.present(alertC, animated: true, completion: nil)
    }

    func dissmissAlertWaitToExport() {
		let buttons: [UIButton] = [self.shareGenericButton, self.expandPlayerButton]
        DispatchQueue.main.async {
            self.alertController?.dismiss(animated: true, completion: nil)
			for button in buttons {
				button.isHidden = false
			}
			self.configureNavigationBarVissible()
			self.tabBarController?.tabBar.isHidden = false
        }
    }

    func showShareGeneric(_ movieURL: URL) {

        let objectsToShare = [movieURL] //comment!, imageData!, myWebsite!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

        activityVC.setValue("Video", forKey: "subject")

        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]

        if (activityVC.popoverPresentationController != nil) {
            activityVC.popoverPresentationController!.sourceView = shareGenericButton
        }

        self.present(activityVC, animated: false, completion: nil)
    }

    func setShareViewObjectsList(_ viewObjects: [ShareViewModel]) {
        self.displayShareObjects = viewObjects
        shareTableView.reloadData()
    }
}
