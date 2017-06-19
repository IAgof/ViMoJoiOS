//
//  Audio4VideoViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import TTRangeSlider
import VideonaProject

protocol Audio4VideoPresenterDelegate {
    func setupSlider(_ value: Float)
}

class Audio4VideoViewController: ViMoJoController, Audio4VideoPresenterDelegate {
    var eventHandler: Audio4VideoPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rangeSlider: TTRangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        rangeSlider.tintColor = configuration.mainColor
    }
    
    func setupSlider(_ value: Float) {
        rangeSlider.maxValue = value
    }
    @IBAction func cancelTapped(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
    
    
    }
}

extension Audio4VideoViewController: TTRangeSliderDelegate{
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        eventHandler?.sliderValue = selectedMaximum
    }
}

extension Audio4VideoViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
