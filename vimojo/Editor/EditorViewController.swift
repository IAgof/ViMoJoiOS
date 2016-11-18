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

class EditorViewController: ViMoJoController,EditorPresenterDelegate,FullScreenWireframeDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate{
    
    //MARK: - VIPER variables
    var eventHandler: EditorPresenterInterface?
    
    //MARK: - Variables
    var longPressGesture: UILongPressGestureRecognizer?
    var currentDragAndDropIndexPath: NSIndexPath?
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        eventHandler?.viewWillAppear()
        
        playerView.layoutSubviews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierCell, forIndexPath: indexPath) as! EditorClipsCell
        
        
        if  videoList.indices.contains(indexPath.item){
            cell.thumbnailImageView.image = videoList[indexPath.item].image
            cell.timeLabel.text = videoList[indexPath.item].timeText
            cell.positionNumberLabel.text = videoList[indexPath.item].positionText
        }
        
        eventHandler?.cellForItemAtIndexPath(indexPath)
    
        cell.removeClipButton.tag = indexPath.row
        
        cell.removeClipButton.addTarget(self, action: #selector(EditorViewController.pushRemoveVideoClip(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
       
        let size = Utils.sharedInstance.thumbnailEditorListDiameter
        
        return CGSize(width: size,
                      height: size)
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        
        eventHandler?.didSelectItemAtIndexPath(indexPath)
    }
    
    //MARK: - Moving Items
    func collectionView(collectionView: UICollectionView,
                        moveItemAtIndexPath sourceIndexPath: NSIndexPath,
                                            toIndexPath destinationIndexPath: NSIndexPath) {
        // move your data order
        
        //        Utils.sharedInstance.debugLog("Move item at index \n sourceIndexPath: \(sourceIndexPath.item) \n destinationIndexPath \(destinationIndexPath.item)")
        
        eventHandler?.moveItemAtIndexPath(sourceIndexPath,
                                          toIndexPath: destinationIndexPath)
        
    }
    
    //MARK: - Actions
    @IBAction func pushRemoveVideoClip(sender:UIButton){
        
        eventHandler?.removeVideoClip(sender.tag)
    }
    
    @IBAction func pushTrimClip(sender:AnyObject){
        
        eventHandler?.pushTrimHandler()
    }
    
    @IBAction func pushDuplicateClip(sender:AnyObject){
        
        eventHandler?.pushDuplicateHandler()
    }
    
    @IBAction func pushDivideClip(sender:AnyObject){
        
        eventHandler?.pushSplitHandler()
    }
    
    @IBAction func pushAddVideo(sender:AnyObject){
        eventHandler?.pushAddVideoHandler()
    }
    
    @IBAction func pushExpandButton(sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    @IBAction func pushAddTextButton(sender: AnyObject) {
        eventHandler?.pushAddTextHandler()
    }
    
    //MARK: - Interface
    func deselectCell(indexPath:NSIndexPath) {
        if (thumbnailClipsCollectionView.cellForItemAtIndexPath(indexPath) != nil){
            let lastCell = thumbnailClipsCollectionView.cellForItemAtIndexPath(indexPath) as! EditorClipsCell
            lastCell.isClipSelected = false
        }
    }
    
    func selectCell(indexPath:NSIndexPath) {
        // Select cell
        if let cell = (thumbnailClipsCollectionView.cellForItemAtIndexPath(indexPath)){
            let editorCell = cell as! EditorClipsCell
            
            editorCell.isClipSelected = true
        }
    }
    
    func reloadCollectionViewData() {
        thumbnailClipsCollectionView.reloadData()
    }
    
    func setVideoList(list: [EditorViewModel]) {
        self.videoList = list
    }
    
    func setUpGestureRecognizer(){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(EditorViewController.handleLongGesture(_:)))
        self.thumbnailClipsCollectionView.addGestureRecognizer(longPressGesture!)
    }
    
    func numberOfCellsInCollectionView() -> Int {
        return self.thumbnailClipsCollectionView.numberOfItemsInSection(0)
    }
    
    func showAlertRemove(title:String,
                         message:String,
                         yesString:String) {
       
        let alertController = UIAlertController(title:title,
                                                message:message,
                                                preferredStyle: .Alert)
        alertController.view.tintColor = VIMOJO_GREEN_UICOLOR

        let yesAction = UIAlertAction(title: yesString,
                                      style: .Default,
                                      handler: {alert -> Void in
            self.eventHandler?.removeVideoClipAfterConfirmation()
                                        self.alertController = nil
        })
        
        let noAction = UIAlertAction(title: "No", style: .Default, handler: {
            void in
            self.alertController = nil
        })
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.presentViewController(alertController, animated: false, completion:{})
    }
    
    func createAlertWaitToImport(completion: (() -> Void)?){
        let title = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_TITLE)
        let message = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_MESSAGE)
        
        alertController = UIAlertController(title:title,message:message,preferredStyle: .Alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        
        activityIndicator.center = CGPointMake(130.5, 70.0);
        activityIndicator.startAnimating()
        
        alertController?.view.addSubview(activityIndicator)
        self.presentViewController(alertController!, animated: false, completion:{
            presented in
            completion!(presented)
        })
    }
    
    func dissmissAlertController(){
        alertController?.dismissViewControllerAnimated(true, completion: {})
    }
    
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
    
    func setTrimViewModel(viewModel: TrimRangeBarViewModel) {
        rangeTrimSlider.maximumValue = viewModel.totalRangeTime
        rangeTrimSlider.lowerValue = viewModel.startTrimTime
        rangeTrimSlider.upperValue = viewModel.finalTrimTime
        rangeTrimSlider.middleValue = viewModel.inserctionPointTime
        rangeTrimSlider.minimumValue = viewModel.startTime
    }
    
    func setTrimMiddleValueToView(value: Double) {
        rangeTrimSlider.middleValue = value
    }
    
    //MARK: - Drag and Drop handler
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.thumbnailClipsCollectionView)) else {
                break
            }
            eventHandler?.didSelectItemAtIndexPath(selectedIndexPath)

            thumbnailClipsCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
            
            guard let cell = thumbnailClipsCollectionView.cellForItemAtIndexPath(selectedIndexPath) as? EditorClipsCell else{
                print("error UIGestureRecognizerState. beginInteractiveMovementForItemAtIndexPath")
                return
            }
            cell.isMoving = true
        
        case UIGestureRecognizerState.Changed:
            thumbnailClipsCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
                     
        case UIGestureRecognizerState.Ended:
            thumbnailClipsCollectionView.endInteractiveMovement()
           
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.thumbnailClipsCollectionView)) else {
                break
            }
            guard let cell = thumbnailClipsCollectionView.cellForItemAtIndexPath(selectedIndexPath) as? EditorClipsCell else{
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
    func seekBarUpdate(value: Float) {
        eventHandler?.seekBarUpdateHandler(value)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        print("navigationController willShowViewController ")
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        print("navigationController didShowViewController ")
    }
}

extension EditorViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
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
    
    func playerSeeksTo(value:Float){
        
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
