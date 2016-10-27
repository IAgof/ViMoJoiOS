//
//  ShareFTPInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Alamofire

class ShareFTPInteractor: ShareActionInterface {
    
    var delegate: ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(path: String) {
        let ftpSettings = SettinsFTP()
        let fileURL = NSURL(string: path)
        
        let destinationURL = FTP
        Alamofire.upload(fileURL, to: "https://httpbin.org/post").responseJSON { response in
            debugPrint(response)
        }
    }
}