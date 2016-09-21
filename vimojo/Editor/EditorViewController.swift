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

class EditorViewController: ViMoJoController,EditorViewInterface,PlayerViewDelegate,PlayerViewSetter,FullScreenWireframeDelegate,
UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //MARK: - VIPER variables
    var eventHandler: EditorPresenterInterface?
    
    //MARK: - Variables
    var longPressGesture: UILongPressGestureRecognizer?
    var currentDragAndDropIndexPath: NSIndexPath?
    let imagePicker = UIImagePickerController()

    let reuseIdentifierCell = "editorCollectionViewCell"
    
    var videoPositionList: [Int] = []

    var videoImageList: [UIImage] = []{
        didSet {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.thumbnailClipsCollectionView.reloadData()
            })
        }
    }
    
    var alertController:UIAlertController?
    
    //MARK: - Outlets
    @IBOutlet weak var thumbnailClipsCollectionView: UICollectionView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoPositionList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierCell, forIndexPath: indexPath) as! EditorClipsCell
        
        cell.positionNumberLabel.text = "\(videoPositionList[indexPath.item])"
        
        if  videoImageList.indices.contains(indexPath.item){
            cell.thumbnailImageView.image = videoImageList[indexPath.item]
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
    
    @IBAction func pushTrimClip(sender:UIButton){
        
        eventHandler?.pushTrimHandler()
    }
    
    @IBAction func pushDuplicateClip(sender:UIButton){
        
        eventHandler?.pushDuplicateHandler()
    }
    
    @IBAction func pushDivideClip(sender:UIButton){
        
        eventHandler?.pushSplitHandler()
    }
    
    @IBAction func pushAddVideo(sender:UIButton){
        eventHandler?.pushAddVideoHandler()
    }
    
    @IBAction func pushExpandButton(sender: AnyObject) {
        eventHandler?.expandPlayer()
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
    
    func setPositionList(list: [Int]) {
        self.videoPositionList = list
    }
    
    func setVideoImagesList(list: [UIImage]) {
        self.videoImageList = list
    }
    
    func setUpGestureRecognizer(){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(EditorViewController.handleLongGesture(_:)))
        self.thumbnailClipsCollectionView.addGestureRecognizer(longPressGesture!)
    }
    
    func numberOfCellsInCollectionView() -> Int {
        return self.thumbnailClipsCollectionView.numberOfItemsInSection(0)
    }
    
    func configurePickerController() {
        imagePicker.delegate = self
    }
    
    func presentPickerController() {
        // Display Photo Library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        
        presentViewController(imagePicker, animated: true, completion: nil)
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
        })
        
        let noAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.presentViewController(alertController, animated: false, completion:{})
    }
    
    func createAlertWaitToImport(){
        let title = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_TITLE)
        let message = Utils().getStringByKeyFromEditor(EditorTextConstants.IMPORT_VIDEO_FROM_PHOTO_LIBRARY_MESSAGE)
        
        alertController = UIAlertController(title:title,message:message,preferredStyle: .Alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        
        activityIndicator.center = CGPointMake(130.5, 70.0);
        activityIndicator.startAnimating()
        
        alertController?.view.addSubview(activityIndicator)
        self.presentViewController(alertController!, animated: false, completion:{})
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
    
    //MARK: - Drag and Drop handler
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.thumbnailClipsCollectionView)) else {
                break
            }
            thumbnailClipsCollectionView.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
            
            let cell = thumbnailClipsCollectionView.cellForItemAtIndexPath(selectedIndexPath) as! EditorClipsCell
            cell.isMoving = true
        
        case UIGestureRecognizerState.Changed:
            thumbnailClipsCollectionView.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
                     
        case UIGestureRecognizerState.Ended:
            thumbnailClipsCollectionView.endInteractiveMovement()
           
            guard let selectedIndexPath = self.thumbnailClipsCollectionView.indexPathForItemAtPoint(gesture.locationInView(self.thumbnailClipsCollectionView)) else {
                break
            }
            let cell = thumbnailClipsCollectionView.cellForItemAtIndexPath(selectedIndexPath) as! EditorClipsCell
            cell.isMoving = false
        default:
            thumbnailClipsCollectionView.cancelInteractiveMovement()
        }
    }
    
    //MARK: Player view delegate
    func seekBarUpdate(value: Float) {
        eventHandler?.seekBarUpdateHandler(value)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        
        // 1
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as String {
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
                    if let url = urlOfVideo {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.createAlertWaitToImport()
                        })

                        eventHandler?.saveVideoToDocuments(url)

                    }
                }
                
            }
        }
        
        // 3
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        eventHandler?.pickerControllerDidCancel()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        print("navigationController willShowViewController ")
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        print("navigationController didShowViewController ")
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
    
}