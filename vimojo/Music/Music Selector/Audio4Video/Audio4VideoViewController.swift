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

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
//    @IBOutlet weak var rangeSlider: TTRangeSlider!
    @IBOutlet weak var rangeSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        configureView()
        configureNavigationBarWithBackButton()
    }

    func configureView() {
//        rangeSlider.layoutIfNeeded()
        //TODO: WIll be removed when change to TTRANGE SLIDER!
        rangeSlider.tintColor = configuration.mainColor
    }

    func setupSlider(_ value: Float) {
//       rangeSlider.maxValue = value
        //TODO: WIll be removed when change to TTRANGE SLIDER!
        rangeSlider.value = value
    }

    override func pushBack() { eventHandler?.cancel() }
    @IBAction func cancelTapped(_ sender: Any) { eventHandler?.cancel() }
    @IBAction func acceptTapped(_ sender: Any) { eventHandler?.accept() }
    //TODO: WIll be removed when change to TTRANGE SLIDER!
    @IBAction func sliderValueChanged(_ sender: UISlider) { eventHandler?.sliderValue = sender.value }
}

//extension Audio4VideoViewController: TTRangeSliderDelegate{
//    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
//        eventHandler?.sliderValue = selectedMaximum
//    }
//}

extension Audio4VideoViewController:PlayerViewSetter {
    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
