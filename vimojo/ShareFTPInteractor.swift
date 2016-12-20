//
//  ShareFTPInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import RebekkaTouch
import VideonaProject
import Photos

class ShareFTPInteractor: ShareActionInterface {
    struct FTPfileData {
        let name:String
        let path:String
    }
    
    var delegate: ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(_ path: String) {
        let title = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_TITLE)
        let message = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_PLACEHOLDER)
        let alertController = ShareUtils().createAlertViewWithInputText(title, message: message, completion: {
            filename in
            
            let fileData = FTPfileData(name: filename + ".m4v", path: path)
            self.createFTPUpload(fileData)
        })
        
        if let controller = UIApplication.topViewController(){
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    fileprivate func createFTPUpload(_ fileData:FTPfileData){
        //For test
        let fileURL = URL(fileURLWithPath: fileData.path)
        
        let ftpSettings = SettinsFTP()
        
        var configuration = SessionConfiguration()
        configuration.host = ftpSettings.host.appendingFormat(":21")
        configuration.username = ftpSettings.username
        configuration.password = ftpSettings.password
        
        let videoResultName = fileData.name
        let path = ftpSettings.editedVideoPath + videoResultName
        
        let session = Session(configuration: configuration)
        session.upload(fileURL, path: path, completionHandler: {
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
    
    fileprivate func handleCorrectUpload(){
        let message = Utils().getStringByKeyFromShare(ShareConstants().UPLOAD_SUCCESFULL)
        
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
    }
    
    fileprivate func handleError(_ errorCode:Int){
            guard let ftpErrorType:FTPErrorType = FTPErrorType(rawValue: errorCode)else {
                print("No ftp error type\(errorCode)")
                return
            }
            var message = ""
            switch ftpErrorType{
            case .ftp_ERROR_HOST_UNREACHABLE,
                 .ftp_ERROR_NO_DOMAIN,
                 .ftp_ERROR_FILE_NOT_FOUND:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_HOST_UNREACHABLE)
                
                break
            case .ftp_ERROR_UNAUTHORIZED:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_UNAUTHORIZED)
                
                break
            case .ftp_ERROR_IO:
                message = Utils().getStringByKeyFromShare(ShareConstants().FTP_ERROR_HOST_UNREACHABLE)
                
                break
            }
        print("FTP error message\(message)")
        
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "FTP",
                                                        message: message)
    }
}
