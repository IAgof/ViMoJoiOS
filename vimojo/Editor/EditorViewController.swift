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
import VideonaRangeSlider
import VideonaProject

class EditorViewController: ViMoJoController,EditorPresenterDelegate,FullScreenWireframeDelegate,
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
                self.thumbnailClipsCollectionView.reloadData()
        }
    }
    
    var alertController:UIAlertController?
    
    //MARK: - Outlets
    @IBOutlet weak var thumbnailClipsCollectionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var rangeTrimSlider: VideonaRangeSlider!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeTrimSlider.delegate = self
        eventHandler?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        eventHandler?.viewWillAppear()
        
        playerView.layoutSubviews()
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
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCell, for: indexPath) as! EditorClipsCell
        
        
        if  videoList.indices.contains(indexPath.item){
            cell.thumbnailImageView.image = videoList[indexPath.item].image
            cell.timeLabel.text = videoList[indexPath.item].timeText
            cell.positionNumberLabel.text = videoList[indexPath.item].positionText
        }
        
        eventHandler?.cellForItemAtIndexPath(indexPath)
    
        cell.removeClipButton.tag = indexPath.row
        
        cell.removeClipButton.addTarget(self, action: #selector(EditorViewController.pushRemoveVideoClip(_:)), for: UIControlEvents.touchUpInside)

        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let size = Utils().thumbnailEditorListDiameter
        
        return CGSize(width: size,
                      height: size)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        eventHandler?.didSelectItemAtIndexPath(indexPath)
    }
    
    //MARK: - Moving Items
    func collectionView(_ collectionView: UICollectionView,
                        moveItemAt sourceIndexPath: IndexPath,
                                            to destinationIndexPath: IndexPath) {
        // move your data order
        
        //        Utils().debugLog("Move item at index \n sourceIndexPath: \(sourceIndexPath.item) \n destinationIndexPath \(destinationIndexPath.item)")
        
        eventHandler?.moveItemAtIndexPath(sourceIndexPath,
                                          toIndexPath: destinationIndexPath)
        
    }
    
    //MARK: - Actions
    @IBAction func pushRemoveVideoClip(_ sender:UIButton){
        
        eventHandler?.removeVideoClip(sender.tag)
    }
    
    @IBAction func pushTrimClip(_ sender:AnyObject){
        
        eventHandler?.pushTrimHandler()
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
    
    //MARK: - Interface
    func deselectCell(_ indexPath:IndexPath) {
        if (thumbnailClipsCollectionView.cellForItem(at: indexPath) != nil){
            let lastCell = thumbnailClipsCollectionView.cellForItem(at: indexPath) as! EditorClipsCell
            lastCell.isClipSelected = false
        }
    }
    
    func selectCell(_ indexPath:IndexPath) {
        // Select cell
        if let cell = (thumbnailClipsCollectionView.cellForItem(at: indexPath)){
            let editorCell = cell as! EditorClipsCell
            
            editorCell.isClipSelected = true
        }
    }
    
    func reloadCollectionViewData() {
        thumbnailClipsCollectionView.reloadData()
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
        alertController.view.tintColor = VIMOJO_GREEN_UICOLOR

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
