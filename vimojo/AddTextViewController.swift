//
//  AddTextViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer
import AVFoundation

class AddTextViewController: ViMoJoController {
    var eventHandler: AddTextPresenterInterface?
    var wireframe:AddTextWireframe?
    var playerHandler: PlayerPresenterInterface?

    let limitLength = 60
    
    @IBOutlet weak var topTextConfigButton: UIButton!
    @IBOutlet weak var midTextConfigButton: UIButton!
    @IBOutlet weak var bottomTextConfigButton: UIButton!
    @IBOutlet weak var addTextTextField: UITextField!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    
    @IBAction func topTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func midTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func bottomTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func addTextTextfieldChanged(sender: AnyObject) {

        print("El texto introducido es: \(addTextTextField)")
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }
    
    @IBAction func acceptButtonPushed(sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
    
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
        
        addTextTextField.delegate = self
    }
    
    
}

extension AddTextViewController:AddTextPresenterDelegate{
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
        playerHandler?.layoutSubViews()
    }
    
    func acceptFinished() {
        wireframe?.goPrevController()
    }
    
    func pushBackFinished() {
        wireframe?.goPrevController()
    }
    
    func expandPlayerToView() {
        wireframe?.presentExpandPlayer()
    }
    
    func setPlayerToSeekTime(time: Float) {
        playerHandler?.seekToTime(time)
    }
    
    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }
    
    func updatePlayerOnView(composition: AVMutableComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }
    
}
extension AddTextViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension AddTextViewController:UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = addTextTextField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
}