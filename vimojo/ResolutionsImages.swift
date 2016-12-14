//
//  ResolutionsImages.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 22/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct ResolutionImage{
    var image:UIImage?
    var imagePressed:UIImage?
    var resolution:String?
    
    init(resolution:String){
        switch resolution {
        case AVCaptureSessionPreset640x480:
            image = UIImage(named:"activity_rec_resolution_720")!
            imagePressed = UIImage(named:"activity_rec_resolution_720")!
            break
        case AVCaptureSessionPreset1280x720:
            image = UIImage(named:"activity_rec_resolution_720")!
            imagePressed = UIImage(named:"activity_rec_resolution_720")!
            break
        case AVCaptureSessionPreset1920x1080:
            image = UIImage(named:"activity_rec_resolution_1080")!
            imagePressed = UIImage(named:"activity_rec_resolution_720")!
            break
        case AVCaptureSessionPreset3840x2160:
            image = UIImage(named:"activity_rec_resolution_4k")!
            imagePressed = UIImage(named:"activity_rec_resolution_4k")!
            break
        default:
            image = UIImage(named:"activity_record_icon_resolution_720")!
            imagePressed = UIImage(named:"activity_record_icon_resolution_720_pressed")!
        }
    }
}
