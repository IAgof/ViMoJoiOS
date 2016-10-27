//
//  ShareFTPInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import RebekkaTouch

enum FTPErrorType:Int {
    case FTP_ERROR_HOST_UNREACHABLE = 60
    case FTP_ERROR_UNAUTHORIZED = 200
    case FTP_ERROR_NO_DOMAIN = 12
    case FTP_ERROR_FILE_NOT_FOUND = 2
    case FTP_ERROR_IO = 50
}


class ShareFTPInteractor: ShareActionInterface {
    struct FTPfileData {
        let name:String
        let path:String
    }
    
    var delegate: ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(path: String) {
        let title = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_TITLE)
        let message = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_PLACEHOLDER)
        let alertController = ShareUtils().createAlertViewWithInputText(title, message: message, completion: {
            filename in
            
            let fileData = FTPfileData(name: filename.stringByAppendingString("m4v"), path: path)
            self.createFTPUpload(fileData)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? EditingRoomViewController {
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    private func createFTPUpload(fileData:FTPfileData){
        let ftpSettings = SettinsFTP()
        //For test
        let fileURL = NSURL(string: fileData.path)
        
        var configuration = SessionConfiguration()
        configuration.host = ftpSettings.host.stringByAppendingString(":21")
        configuration.username = ftpSettings.username
        configuration.password = ftpSettings.password
        
        if let URL = fileURL {
            let videoResultName = fileData.name
            let path = ftpSettings.editedVideoPath.stringByAppendingString(videoResultName)
            
            let session = Session(configuration: configuration)
            session.upload(URL, path: path, completionHandler: {
                (result, error) -> Void in
                if result{
                    self.handleCorrectUpload()
                }else{
                    guard let errorCode = error?.code else {
                        print("No error code")
                        return
                    }
                    self.handleError(errorCode)
                }
            })
        }
    }
    
    private func handleCorrectUpload(){
        let message = Utils().getStringByKeyFromShare(ShareConstants().UPLOAD_SUCCESFULL)
        
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
    }
    
    private func handleError(errorCode:Int){
            guard let ftpErrorType:FTPErrorType = FTPErrorType(rawValue: errorCode)else {
                print("No ftp error type\(errorCode)")
                return
            }
            var message = ""
            switch ftpErrorType{
            case .FTP_ERROR_HOST_UNREACHABLE,.FTP_ERROR_NO_DOMAIN:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_HOST_UNREACHABLE)
                
                break
            case .FTP_ERROR_UNAUTHORIZED:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_UNAUTHORIZED)
                
                break
            case .FTP_ERROR_FILE_NOT_FOUND:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_FILE_NOT_FOUND)
                
                break
            case .FTP_ERROR_IO:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_HOST_UNREACHABLE)
                
                break
            }
        print("FTP error message\(message)")
        
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
    }
}