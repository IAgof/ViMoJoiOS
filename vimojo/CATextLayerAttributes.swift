//
//  CATextLayerAttributes.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct CATextLayerAttributes {
    enum HorizontalAlignment: String {
        case left = "left"
        case center = "center"
        case right = "right"
    }

    enum HelveticaFont: String {
        case normal = "Helvetica"
        case bold = "Helvetica-Bold"
        case light = "Helvetica-Light"
    }

    enum FontSize: CGFloat {
        case small = 75
        case medium = 100
        case big = 250
    }

    enum VerticalAlignment: Int {
        case top = 0
        case mid = 1
        case bottom = 2
    }

    var font: UIFont = UIFont(name: HelveticaFont.normal.rawValue, size: FontSize.medium.rawValue)!
    var textColor: UIColor = UIColor.whiteColor()
    var horizontalAlignment: HorizontalAlignment = .left
    var verticalAlignment: VerticalAlignment = .top
    var fontSize: CGFloat = FontSize.medium.rawValue

    init() {

    }

    init(horizontalAlignment: HorizontalAlignment,
         verticalAlignment: VerticalAlignment,
         font: HelveticaFont,
         fontSize: FontSize) {

        guard let newFont = UIFont(name: font.rawValue, size: fontSize.rawValue) else {return}
        self.font = newFont
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.fontSize = fontSize.rawValue
    }

    func getFrameForString(frame: CGRect) -> CGRect {
        let vertical = CGFloat(verticalAlignment.rawValue)
        let height = fontSize * 2 + 30

        let xPositionOffset: CGFloat = 20.0
        let yPositionOffset: CGFloat = height/2

        switch verticalAlignment {
        case .top:
            return CGRectMake(xPositionOffset, 10, frame.width, height)
        case .mid:
            let yPosition = max(0, ((frame.height/2*vertical) - yPositionOffset))

            return CGRectMake(xPositionOffset, yPosition, frame.width, height)
        case .bottom:
            let yPosition = max(0, ((frame.height/2*vertical) - yPositionOffset*2))

            return  CGRectMake(xPositionOffset, yPosition, frame.width, height)

        }
    }

    func getAlignmentAttributesByType(type: VerticalAlignment) -> CATextLayerAttributes {
        switch type {
        case .top:
            return CATextLayerAttributes(horizontalAlignment: .left,
                                         verticalAlignment: .top,
                                         font: .bold,
                                         fontSize: .medium)
        case .mid:
            return CATextLayerAttributes(horizontalAlignment: .center,
                                         verticalAlignment: .mid,
                                         font: .bold,
                                         fontSize: .medium)
        case .bottom:
            return  CATextLayerAttributes(horizontalAlignment: .left,
                                          verticalAlignment: .bottom,
                                          font: .light,
                                          fontSize: .medium)
        }
    }
}
