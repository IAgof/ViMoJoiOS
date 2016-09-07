//
//  BatteryRemainingView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import MBCircularProgressBar

protocol BatteryRemainingDelegate {
    func closeButtonPushed()
}

public class BatteryRemainingView: UIView,BatteryRemainingPresenterDelegate {
    //MARK: - VIPER
    var eventHandler: BatteryRemainingPresenterInterface?
    var delegate:BatteryRemainingDelegate?
    
    // Our custom view from the XIB file
    var view: UIView!
    
    //MARK: - Outlet
    @IBOutlet weak var batteryProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var batteryTimeLeft: UILabel!
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        eventHandler = BatteryRemainingPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here

        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        eventHandler = BatteryRemainingPresenter(controller: self)

        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        view.layer.cornerRadius = 4
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BatteryRemainingView", bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

    @IBAction func closeWindowPushed(sender: AnyObject) {
        delegate?.closeButtonPushed()
    }
    
    public func updateValues(){
        eventHandler?.updateBatteryLevel()
    }
    
    //MARK: presenter delegate
    func updateBarValue(value: CGFloat) {
        batteryProgressBar.value = value
    }
    func updateBarColor(color: UIColor) {
        batteryProgressBar.progressColor = color
    }
    func updateTextTimeLeft(text: String) {
        batteryTimeLeft.text = text
    }
}
