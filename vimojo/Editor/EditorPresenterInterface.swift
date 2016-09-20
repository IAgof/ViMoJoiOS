//
//  EditorPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer

protocol EditorPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func didSelectItemAtIndexPath(indexPath:NSIndexPath)
    func cellForItemAtIndexPath(indexPath:NSIndexPath)
    func moveItemAtIndexPath(sourceIndexPath: NSIndexPath,
                             toIndexPath destinationIndexPath: NSIndexPath)
    func removeVideoClip(position:Int)
    func removeVideoClipAfterConfirmation()
    
    func pushTrimHandler()
    func pushDuplicateHandler()
    func pushSplitHandler()
    func seekBarUpdateHandler(value: Float)
    func pushAddVideoHandler()
    func saveVideoToDocuments(url:NSURL)
    
    func pickerControllerDidCancel()
   
    func expandPlayer()
    func updatePlayerLayer()

}