//
//  EditorPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

protocol VideonaPlayerViewInterface {
    func add(compositionToPlayer: VideoComposition)
}
protocol EditorPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func didSelectItemAtIndexPath(_ indexPath: IndexPath)
    func moveItemAtIndexPath(_ sourceIndexPath: IndexPath,
                             toIndexPath destinationIndexPath: IndexPath)
    func removeVideoClip(_ position: Int)
    func removeVideoClipAfterConfirmation()

    func pushDuplicateHandler()
    func pushSplitHandler()
    func pushTrimHandler()
    func pushAddTextHandler()
    func pushAddFloating()
    func pushOptions()

    func addSelection(selection: String)

    func seekBarUpdateHandler(_ value: Float)
    func pushAddVideoHandler()
}

protocol EditorPresenterDelegate: ViMoJoInterface, VideonaPlayerViewInterface {
    func setUpGestureRecognizer()
    func selectCell(_ indexPath: IndexPath)
    func setVideoList(_ list: [EditorViewModel])
    func numberOfCellsInCollectionView() -> Int
    func showAlertRemove(_ title: String,
                         message: String,
                         yesString: String)

    func createAlertWaitToImport(_ completion: @escaping (() -> Void))
    func createAlertWithAddOptions(title: String,
                                   options: [String])
    func dissmissAlertController()
    func bringToFrontExpandPlayerButton()
}
