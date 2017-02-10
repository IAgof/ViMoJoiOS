//
//  EditorViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import MobileCoreServices
import VideonaPlayer
import VideonaProject
import Photos

class EditorViewController: EditingRoomItemController,EditorPresenterDelegate,FullScreenWireframeDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate{
    
    //MARK: - VIPER variables
    var eventHandler: EditorPresenterInterface?
    
    //MARK: - Variables
    var longPressGesture: UILongPressGestureRecognizer?
    var currentDragAndDropIndexPath: IndexPath?
    let imagePicker = UIImagePickerController()

    let reuseIdentifierCell = "editorCollectionViewCell"
    
    var videoList: [EditorViewModel] = []{
        didSet {
            DispatchQueue.main.async {
                self.thumbnailClipsCollectionView.reloadData()
            }
        }
    }
    
    var alertController:UIAlertController?
    
    //MARK: - Outlets
    @IBOutlet weak var thumbnailClipsCollectionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var rangeTrimSlider: VideonaRangeSlider!
    @IBOutlet weak var addFloatingButton: UIButton!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeTrimSlider.delegate = self
        configureUITrimSlider()
        eventHandler?.viewDidLoad()
    }

    func configureUITrimSlider(){
        rangeTrimSlider.backgroundSliderColor = configuration.mainColor
        rangeTrimSlider.middleSliderColor = configuration.mainColor
        rangeTrimSlider.untrackedAreaColor = configuration.secondColor
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
    
    func configureNavigationBarWithDrawerAndEditorOptions(){
        
        
        let sideSliderIcon = #imageLiteral(resourceName: "activity_edit_drawer")
        let optionsIcon = #imageLiteral(resourceName: "activity_edit_options")
        let duplicateIcon = #imageLiteral(resourceName: "activity_edit_clips_duplicate")
        let splitIcon = #imageLiteral(resourceName: "activity_edit_clips_split")
        
        let showSideSliderItem = UIBarButtonItem(image: sideSliderIcon, style: .plain, target: self, action: #selector(pushShowDrawer))
        let duplicateItem = UIBarButtonItem(image: duplicateIcon, style: .plain, target: self, action: #selector(pushDuplicateClip(_:)))
        let splitItem = UIBarButtonItem(image: splitIcon, style: .plain, target: self, action: #selector(pushDivideClip(_:)))
        let optionsItem = UIBarButtonItem(image: optionsIcon, style: .plain, target: self, action: #selector(pushOptions))
        
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = showSideSliderItem
        UIApplication.topViewController()?.navigationItem.rightBarButtonItems = [optionsItem,splitItem,duplicateItem]
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
        
        if  videoList.indices.contains(indexItem){
            DispatchQueue.main.async{
                PHImageManager.default().requestImage(for: self.videoList[indexItem].phAsset,
                                                      targetSize: cell.thumbnailImageView.size,
                                                      contentMode: .aspectFill,
                                                      options: nil,
                                                      resultHandler: {(result, info)in
                                                        if let image = result {
                                                                cell.thumbnailImageView.image = image
                                                        }
                })
            }
            
            cell.timeLabel.text = videoList[indexItem].timeText
            cell.positionNumberLabel.text = "\(indexItem + 1)"
        }
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = configuration.mainColor
        cell.selectedBackgroundView = selectedBackgroundView
        
        cell.removeClipButton.tag = indexItem
        cell.removeClipButton.addTarget(self, action: #selector(EditorViewController.pushRemoveVideoClip(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let size = (collectionView.frame.width/4) - 4
        
        return CGSize(width: size,
                      height: size)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventHandler?.didSelectItemAtIndexPath(indexPath)
    }
    
    //MARK: - Moving Items
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                                            to destinationIndexPath: IndexPath) {
        eventHandler?.moveItemAtIndexPath(sourceIndexPath,
                                          toIndexPath: destinationIndexPath)
    }
    
    //MARK: - Actions
    @IBAction func pushRemoveVideoClip(_ sender:UIButton){
        
        eventHandler?.removeVideoClip(sender.tag)
    }
    
    @IBAction func pushDuplicateClip(_ sender:AnyObject){
        
        eventHandler?.pushDuplicateHandler()
    }
    
    @IBAction func pushDivideClip(_ sender:AnyObject){
        
        eventHandler?.pushSplitHandler()
    }
    
    @IBAction func pushAddVideo(_ sender:AnyObject){
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
    
    //MARK: - Interface
    func deselectCell(_ indexPath:IndexPath) {
        DispatchQueue.main.async {
            if let cell = (self.thumbnailClipsCollectionView.cellForItem(at: indexPath)){
                cell.isSelected = false
            }
        }
    }
    
    func selectCell(_ indexPath:IndexPath) {
        // Select cell
        DispatchQueue.main.async {
            if let cell = (self.thumbnailClipsCollectionView.cellForItem(at: indexPath)){
                cell.isSelected = true
            }
        }
    }
    
    func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.thumbnailClipsCollectionView.reloadData()
        }
    }
    
    func setVideoList(_ list: [EditorViewModel]) {
        self.videoList = list
    }
    
    func setUpGestureRecognizer(){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(EditorViewController.handleLongGesture(_:)))
        self.thumbnailClipsCollectionView.addGestureRecognizer(longPressGesture!)
    }
    
    func numberOfCellsInCollectionView() -> Int {
        return self.thumbnailClipsCollectionView.numberOfItems(inSection: 0)
    }
    
    func showAlertRemove(_ title:String,
                         message:String,
                         yesString:String) {
       
        let alertController = UIAlertController(title:title,
                                                message:message,
                                                preferredStyle: .alert)
        alertController.setTintColor()

        let yesAction = UIAlertAction(title: yesString,
                                      style: .default,
                                      handler: {alert -> Void in
            self.eventHandler?.removeVideoClipAfterConfirmation()
                                        self.alertController = nil
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: {
            void in
            self.alertController = nil
        })
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: false, completion:{})
    }
    
    func createAlertWaitToImport(_ completion: @escaping (() -> Void)){
        let title = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_TITLE)
        let message = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_MESSAGE)
        
        alertController = UIAlertController(title:title,message:message,preferredStyle: .alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        
        activityIndicator.center = CGPoint(x: 130.5, y: 70.0);
        activityIndicator.startAnimating()
        
        alertController?.view.addSubview(activityIndicator)
        self.present(alertController!, animated: false, completion:{
            presented in
            completion()
        })
    }
    
    func createAlertWithAddOptions(title:String,
                                   options:[String]){
        
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
    
    func dissmissAlertController(){
        alertController?.dismiss(animated: true, completion: {})
    }
    
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(_ playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
    
    func setTrimViewModel(_ viewModel: TrimRangeBarViewModel) {
        rangeTrimSlider.maximumValue = viewModel.totalRangeTime
        rangeTrimSlider.lowerValue = viewModel.startTrimTime
        rangeTrimSlider.upperValue = viewModel.finalTrimTime
        rangeTrimSlider.middleValue = viewModel.inserctionPointTime
        rangeTrimSlider.minimumValue = viewModel.startTime
    }
    
    func setTrimMiddleValueToView(_ value: Double) {
        rangeTrimSlider.middleValue = value
    }
    
    //MARK: - Drag and Drop handler
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItem(at: gesture.location(in: self.thumbnailClipsCollectionView)) else {
                break
            }
            eventHandler?.didSelectItemAtIndexPath(selectedIndexPath)

            thumbnailClipsCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
            guard let cell = thumbnailClipsCollectionView.cellForItem(at: selectedIndexPath) as? EditorClipsCell else{
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
            guard let cell = thumbnailClipsCollectionView.cellForItem(at: selectedIndexPath) as? EditorClipsCell else{
                print("error UIGestureRecognizerState. Ended")
                return}
            cell.isMoving = false
        default:
            thumbnailClipsCollectionView.cancelInteractiveMovement()
        }
    }
}

extension EditorViewController:PlayerViewDelegate{
    //MARK: Player view delegate
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

extension EditorViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension EditorViewController:PlayerViewFinishedDelegate{
    func playerHasLoaded(){
        eventHandler?.playerHasLoaded()
    }
    func playerStartsToPlay(){
        
    }
    func playerPause(){
        
    }
    
    func playerSeeksTo(_ value:Float){
        eventHandler?.seekBarUpdateHandler(value)
    }
}
extension EditorViewController:VideonaRangeSliderDelegate{
    func rangeSliderLowerValueStartToChange() {
        eventHandler?.rangeSliderUpperOrLowerValueStartToChange()
    }
    
    func rangeSliderLowerThumbValueChanged() {
        eventHandler?.rangeSliderUpperOrLowerValueChanged(rangeTrimSlider.lowerValue)
    }
    
    func rangeSliderLowerValueStopToChange() {
        eventHandler?.rangeSliderLowerValueStopToChange(rangeTrimSlider.lowerValue,
                                                               stopTime: rangeTrimSlider.upperValue)
    }
    
    func rangeSliderMiddleThumbValueChanged() {
        print("range Trim Slider middleValue")
        print(rangeTrimSlider.middleValue)
        eventHandler?.rangeMiddleValueChanged(rangeTrimSlider.middleValue)
    }
    
    func rangeSliderUpperValueStartToChange() {
        eventHandler?.rangeSliderUpperOrLowerValueStartToChange()
    }
    
    func rangeSliderUpperThumbValueChanged() {
        eventHandler?.rangeSliderUpperOrLowerValueChanged(rangeTrimSlider.upperValue)
    }
    
    func rangeSliderUpperValueStopToChange() {
        eventHandler?.rangeSliderUpperValueStopToChange(rangeTrimSlider.lowerValue,
                                                               stopTime: rangeTrimSlider.upperValue)
    }
}
