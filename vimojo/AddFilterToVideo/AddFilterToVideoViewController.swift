//
//  AddFilterToVideoViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import TTRangeSlider
import VideonaProject

class AddFilterToVideoViewController: EditingRoomItemController {
    var eventHandler: AddFilterToVideoPresenterInterface?

    @IBOutlet weak var brightnessSlider: TTRangeSlider!
    @IBOutlet weak var contrastSlider: TTRangeSlider!
    @IBOutlet weak var exposureSlider: TTRangeSlider!
    @IBOutlet weak var saturationSlider: TTRangeSlider!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var defaultButton: UIButton!

    var filters = Array<FilterCollectionViewModel>() {
        didSet {
            filtersCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {

        eventHandler?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        eventHandler?.viewWillAppear()
        configureNavigationBarWithDrawerAndOptions()
        configureView()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")

        changeDefaultButtonColor(toColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }

    @IBAction func pushDefaultParameters(_ sender: Any) {
        eventHandler?.setDefaultParameters()
        changeDefaultButtonColor(toColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }

    override func pushOptions() {
        eventHandler?.pushOptions()
    }

    func configureView() {
        var sliders: [TTRangeSlider] = []
        sliders.append(brightnessSlider)
        sliders.append(contrastSlider)
        sliders.append(exposureSlider)
        sliders.append(saturationSlider)

        let customFormatter = NumberFormatter()
        customFormatter.positiveSuffix = "%"

        for slider in sliders {
            slider.delegate = self
            slider.numberFormatterOverride = customFormatter
            slider.tintColor = configuration.mainColor
            slider.handleColor = configuration.mainColor
            slider.tintColorBetweenHandles = configuration.mainColor
        }

        brightnessSlider.tag = VideoParameterSlider.brightness.rawValue
        contrastSlider.tag = VideoParameterSlider.contrast.rawValue
        exposureSlider.tag = VideoParameterSlider.exposure.rawValue
        saturationSlider.tag = VideoParameterSlider.saturation.rawValue
    }

    func changeDefaultButtonColor(toColor color: UIColor) {
        defaultButton.setTitleColor(color, for: .normal)
        defaultButton.layer.borderColor = color.cgColor
    }
}

extension AddFilterToVideoViewController:PlayerViewSetter {
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
extension AddFilterToVideoViewController:PlayerViewFinishedDelegate {
    func playerHasLoaded() {
        eventHandler?.playerIsReady()
    }

    func playerStartsToPlay() {}
    func playerPause() {}
    func playerSeeksTo(_ value: Float) {}
}

extension AddFilterToVideoViewController:AddFilterToVideoPresenterDelegate {
    func setFilters(filters: [FilterCollectionViewModel]) {
        self.filters = filters
    }

    func setUpView(withParameters parameters: ProjectParametersViewModel) {
        brightnessSlider.selectedMaximum = parameters.brightness
        contrastSlider.selectedMaximum = parameters.contrast
        exposureSlider.selectedMaximum = parameters.exposure
        saturationSlider.selectedMaximum = parameters.saturation

        guard let selectedFilterPos = parameters.filterSelectedPosition else {return}
        if selectedFilterPos < filters.count {
            DispatchQueue.main.async {
                let indexPath = IndexPath(item: selectedFilterPos, section: 0)
                self.filtersCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
    }

    func deselectFilter(inPosition: Int) {
        let indexPath = IndexPath(item: inPosition, section: 0)
        self.filtersCollectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension AddFilterToVideoViewController:TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        changeDefaultButtonColor(toColor: configuration.mainColor)

        guard let sliderMoved = VideoParameterSlider(rawValue: sender.tag) else {return}
        switch sliderMoved {
        case .brightness:
            eventHandler?.parameterSliderValueChanged(sliderValue: brightnessSlider.selectedMaximum, parameterType: .brightness)
            break
        case .contrast:
            eventHandler?.parameterSliderValueChanged(sliderValue: contrastSlider.selectedMaximum, parameterType: .contrast)
            break
        case .exposure:
            eventHandler?.parameterSliderValueChanged(sliderValue: exposureSlider.selectedMaximum, parameterType: .exposure)
            break
        case .saturation:
            eventHandler?.parameterSliderValueChanged(sliderValue: saturationSlider.selectedMaximum, parameterType: .saturation)
            break
        }
    }
}
