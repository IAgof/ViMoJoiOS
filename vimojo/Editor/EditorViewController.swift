//
//  EditorViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import MobileCoreServices
import VideonaProject
import VideonaProject
import Photos

class EditorViewController: EditingRoomItemController, EditorPresenterDelegate, FullScreenWireframeDelegate,
UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
	// MARK: - VIPER variables
    var eventHandler: EditorPresenterInterface?
    // MARK: - Variables
    var longPressGesture: UILongPressGestureRecognizer?
    var currentDragAndDropIndexPath: IndexPath?
    let imagePicker = UIImagePickerController()
    let reuseIdentifierCell = "editorCollectionViewCell"
    var videosCount: Int = 0
    var videoList: [EditorViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.videosCount = self.videoList.count
                self.thumbnailClipsCollectionView.reloadData()
            }
        }
    }
    var alertController: UIAlertController?
    var selectedCellIndexPath: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            DispatchQueue.main.async {
                if let cell = (self.thumbnailClipsCollectionView.cellForItem(at: oldValue)) { cell.isSelected = false }
                if let cell = (self.thumbnailClipsCollectionView.cellForItem(at: self.selectedCellIndexPath)) { cell.isSelected = true }
            }
        }
    }
    var removeVideoAction: (IndexPath) -> Void {
        return { indice in
            self.thumbnailClipsCollectionView.performBatchUpdates({
                self.videosCount -= 1
                self.thumbnailClipsCollectionView.deleteItems(at: [indice])
            }, completion: { (finished) in
                guard finished else { return }
                self.videoList.remove(at: indice.row)
                self.eventHandler?.removeVideoClip(at: indice)
                self.thumbnailClipsCollectionView.reloadItems(at: self.thumbnailClipsCollectionView.indexPathsForVisibleItems)
            })
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var thumbnailClipsCollectionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var addFloatingButton: UIButton!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
		UIApplication.shared.statusBarView?.backgroundColor = configuration.mainColor
        eventHandler?.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.viewWillAppear()
        playerView.layoutSubviews()
    }
    override func viewWillAppear(_ animated: Bool) {
		configureNavigationBarWithDrawerAndOptions()
		configureNavigationBarVissible()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCell, for: indexPath) as! EditorClipsCell
        let indexItem = indexPath.item
        if videoList.indices.contains(indexItem) {
			cell.thumbnailImageView.image = videoList[indexItem].thumbnail
            cell.timeLabel.text = videoList[indexItem].timeText
            cell.positionNumberLabel.text = "\(indexItem + 1)"
        }
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = configuration.mainColor
        cell.selectedBackgroundView = selectedBackgroundView
        cell.isSelected = (selectedCellIndexPath == indexPath)
        cell.removeClipButton.add(for: .touchUpInside) {
            self.showAlertRemove(Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_TITLE),
                            message: Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_MESSAGE),
                            yesString: Utils().getStringByKeyFromEditor(EditorTextConstants.YES_ACTION)) {
                                self.removeVideoAction(indexPath)
            }
        }
        return cell
    }
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let offset: CGFloat = 32//collectionView.contentInset.right + collectionView.contentInset.left
        let size = ((UIScreen.main.bounds.width - offset) / 4 ) - 4
        return CGSize(width: size,
                      height: size)
    }
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler?.didSelectItemAtIndexPath(indexPath)
    }
    // MARK: - Moving Items
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                                            to destinationIndexPath: IndexPath) {
        eventHandler?.moveItemAtIndexPath(sourceIndexPath,
                                          toIndexPath: destinationIndexPath)
        DispatchQueue.main.async {
            let video = self.videoList.remove(at: sourceIndexPath.row)
            self.videoList.insert(video, at: destinationIndexPath.row)
            self.thumbnailClipsCollectionView
                .reloadItems(at: self.thumbnailClipsCollectionView.indexPathsForVisibleItems)
        }
    }
    // MARK: - Actions
    @IBAction func pushDuplicateClip(_ sender: AnyObject) {
        eventHandler?.pushDuplicateHandler()
    }
	@IBAction func pushTrimClip(_ sender: AnyObject) {
        eventHandler?.pushTrimHandler()
    }
    @IBAction func pushDivideClip(_ sender: AnyObject) {
        eventHandler?.pushSplitHandler()
    }
    @IBAction func pushAddVideo(_ sender: AnyObject) {
        eventHandler?.pushAddVideoHandler()
    }
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    @IBAction func pushAddTextButton(_ sender: AnyObject) {
        eventHandler?.pushAddTextHandler()
    }
    @IBAction func pushAddFloatingButton(_ sender: Any) {
        eventHandler?.pushAddFloating()
    }
    @IBAction func pushOptionsButton(_ sender: Any) {
        eventHandler?.pushOptions()
    }
    override func pushOptions() {
        eventHandler?.pushOptions()
    }
    // MARK: - Interface
    func selectCell(_ indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
    }
    func setVideoList(_ list: [EditorViewModel]) {
        self.videoList = list
    }
    func setUpGestureRecognizer() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(EditorViewController.handleLongGesture(_:)))
        self.thumbnailClipsCollectionView.addGestureRecognizer(longPressGesture!)
    }
    func numberOfCellsInCollectionView() -> Int {
        return self.thumbnailClipsCollectionView.numberOfItems(inSection: 0)
    }
    func showAlertRemove(_ title: String,
                         message: String,
                         yesString: String,
                         removeAction: @escaping Action) {
        let alertController = UIAlertController(title:title,
                                                message:message,
                                                preferredStyle: .alert)
        alertController.setTintColor()
        let yesAction = UIAlertAction(title: yesString,
                                      style: .default,
                                      handler: {_ -> Void in
                                        removeAction()
                                        self.alertController = nil
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            _ in
            self.alertController = nil
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: false, completion: {})
    }
    func createAlertWaitToImport(_ completion: @escaping (() -> Void)) {
        let title = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_TITLE)
        let message = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_MESSAGE)
        alertController = UIAlertController(title:title, message:message, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicator.center = CGPoint(x: 130.5, y: 70.0)
        activityIndicator.startAnimating()
        alertController?.view.addSubview(activityIndicator)
        self.present(alertController!, animated: false, completion: {
            _ in
            completion()
        })
    }
    func createAlertWithAddOptions(title: String,
                                   options: [String]) {
        let alertController = SettingsUtils().createActionSheetWithOptions(title,
                                                                           options: options,
                                                                           completion: {
                                                                            response in
                                                                            print("response add options")
                                                                            print(response)
                                                                            self.eventHandler?.addSelection(selection: response)
        })
        alertController.setTintColor()
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = addFloatingButton
        }
        self.present(alertController, animated: true, completion: nil)
    }
    func dissmissAlertController() {
        alertController?.dismiss(animated: true, completion: {})
    }
    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }
    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
		self.playerView.addSubview(playerView)
		self.playerView.bringSubview(toFront: expandPlayerButton)
		eventHandler?.updatePlayerLayer()
    }
    // MARK: - Drag and Drop handler
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItem(at: gesture.location(in: self.thumbnailClipsCollectionView)) else {
                break
            }
            eventHandler?.didSelectItemAtIndexPath(selectedIndexPath)
            thumbnailClipsCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            guard let cell = thumbnailClipsCollectionView.cellForItem(at: selectedIndexPath) as? EditorClipsCell else {
                print("error UIGestureRecognizerState. beginInteractiveMovementForItemAtIndexPath")
                return
            }
            cell.isMoving = true
        case UIGestureRecognizerState.changed:
            thumbnailClipsCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            thumbnailClipsCollectionView.endInteractiveMovement()
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItem(at: gesture.location(in: self.thumbnailClipsCollectionView)) else {
                break
            }
            guard let cell = thumbnailClipsCollectionView.cellForItem(at: selectedIndexPath) as? EditorClipsCell else {
                print("error UIGestureRecognizerState. Ended")
                return}
            cell.isMoving = false
        default:
            thumbnailClipsCollectionView.cancelInteractiveMovement()
        }
    }
}
extension EditorViewController:PlayerViewDelegate {
    // MARK: Player view delegate
    func seekBarUpdate(_ value: Float) {
        eventHandler?.seekBarUpdateHandler(value)
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print("navigationController willShowViewController ")
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print("navigationController didShowViewController ")
    }
}
extension EditorViewController:PlayerViewSetter {
    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
extension EditorViewController:PlayerViewFinishedDelegate {
    func playerHasLoaded() {
        eventHandler?.playerHasLoaded()
    }
    func playerStartsToPlay() { }
    func playerPause() { }
    func playerSeeksTo(_ value: Float) {
        eventHandler?.seekBarUpdateHandler(value)
    }
}
