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

    var videoList: [EditorViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
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

    // MARK: - Outlets
    @IBOutlet weak var thumbnailClipsCollectionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var addFloatingButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        eventHandler?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        eventHandler?.viewWillAppear()

        playerView.layoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithDrawerAndEditorOptions()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }

    func configureNavigationBarWithDrawerAndEditorOptions() {

        // let showSideSliderItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_drawer"), style: .plain, target: self, action: #selector(pushShowDrawer))
        // let duplicateItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_clips_duplicate"), style: .plain, target: self, action: #selector(pushDuplicateClip(_:)))
        // let trimItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_clips_trim"), style: .plain, target: self, action: #selector(pushTrimClip))
        // let splitItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_clips_split"), style: .plain, target: self, action: #selector(pushDivideClip(_:)))
        // let optionsItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_options"), style: .plain, target: self, action: #selector(pushOptions))
        
        // UIApplication.topViewController()?.navigationItem.rightBarButtonItems = [optionsItem, splitItem, duplicateItem, trimItem]
        let showSideSliderItem = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        showSideSliderItem.setBackgroundImage(UIImage(named: "activity_edit_drawer"), for: .normal)
        showSideSliderItem.addTarget(self, action: #selector(pushShowDrawer), for: .touchUpInside)
        
        let splitItem = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 21))
        splitItem.setBackgroundImage(UIImage(named: "activity_edit_clips_split"), for: .normal)
        splitItem.addTarget(self, action: #selector(pushDivideClip(_:)), for: .touchUpInside)
        
        let trimItem = UIButton(frame: CGRect(x: 0, y: 0, width: 29, height: 22))
        trimItem.setBackgroundImage(UIImage(named: "activity_edit_clips_trim"), for: .normal)
        trimItem.addTarget(self, action: #selector(pushTrimClip), for: .touchUpInside)
        
        let duplicateItem = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        duplicateItem.setBackgroundImage(UIImage(named: "activity_edit_clips_duplicate"), for: .normal)
        duplicateItem.addTarget(self, action: #selector(pushDuplicateClip(_:)), for: .touchUpInside)
        
        let optionsItem = UIButton(frame: CGRect(x: 0, y: 0, width: 5, height: 15))
        optionsItem.setBackgroundImage(UIImage(named: "activity_edit_options"), for: .normal)
        optionsItem.addTarget(self, action: #selector(pushOptions), for: .touchUpInside)
        
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:showSideSliderItem)
        UIApplication.topViewController()?.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: optionsItem), UIBarButtonItem(customView: splitItem), UIBarButtonItem(customView: duplicateItem), UIBarButtonItem(customView: trimItem)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCell, for: indexPath) as! EditorClipsCell
        let indexItem = indexPath.item

        if  videoList.indices.contains(indexItem) {
            DispatchQueue.main.async {
                PHImageManager.default().requestImage(for: self.videoList[indexItem].phAsset,
                                                      targetSize: cell.thumbnailImageView.size,
                                                      contentMode: .aspectFill,
                                                      options: nil,
                                                      resultHandler: {(result, _)in
                                                        cell.thumbnailImageView.image = result ?? #imageLiteral(resourceName: "video_removed")
                })
            }

            cell.timeLabel.text = videoList[indexItem].timeText
            cell.positionNumberLabel.text = "\(indexItem + 1)"
        }

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = configuration.mainColor
        cell.selectedBackgroundView = selectedBackgroundView

        cell.isSelected = (selectedCellIndexPath == indexPath)
        cell.removeClipButton.tag = indexItem
        cell.removeClipButton.addTarget(self, action: #selector(EditorViewController.pushRemoveVideoClip(_:)), for: UIControlEvents.touchUpInside)

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
    }

    // MARK: - Actions
    @IBAction func pushRemoveVideoClip(_ sender: UIButton) {

        eventHandler?.removeVideoClip(sender.tag)
    }

    @IBAction func pushDuplicateClip(_ sender: AnyObject) {

        eventHandler?.pushDuplicateHandler()
    }

    func pushTrimClip() {
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
                         yesString: String) {

        let alertController = UIAlertController(title:title,
                                                message:message,
                                                preferredStyle: .alert)
        alertController.setTintColor()

        let yesAction = UIAlertAction(title: yesString,
                                      style: .default,
                                      handler: {_ -> Void in
            self.eventHandler?.removeVideoClipAfterConfirmation()
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
    func playerStartsToPlay() {

    }
    func playerPause() {

    }

    func playerSeeksTo(_ value: Float) {
        eventHandler?.seekBarUpdateHandler(value)
    }
}
