//
//  ShareConstants.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 10/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct ShareConstants{
    static var  NO_WHATSAPP_INSTALLED:String{
        return getStringByKeyFromShare("no_whatsapp_installed")
    }
    static var  NO_ISTAGRAM_INSTALLED:String{
        return getStringByKeyFromShare("no_facebook_installed")
    }
    static var  NO_FACEBOOK_INSTALLED:String{
        return getStringByKeyFromShare("no_facebook_installed")
    }
    static var  OK:String{
        return getStringByKeyFromShare("OK")
    }
    static var  UPLOADING_VIDEO:String{
        return getStringByKeyFromShare("uploadingVideo")
    }
    static var  PLEASE_WAIT:String{
        return getStringByKeyFromShare("pleaseWait")
    }
    static var  YOUTUBE_DESCRIPTION:String{
        return getStringByKeyFromShare("descriptionYoutube")
    }
    static var  YOUTUBE_TITLE:String{
        return getStringByKeyFromShare("titleYoutube")
    }
    static var  UPLOAD_SUCCESFULL:String{
        return getStringByKeyFromShare("uploadSuccesfull")
    }
    static var  UPLOAD_FAIL:String{
        return getStringByKeyFromShare("uploadFail")
    }
    static var  VIDEONATIME_HASTAGH:String{
        return getStringByKeyFromShare("videonaHastagh")
    }
    static var  NO_TWITTER_ACCESS:String{
        return getStringByKeyFromShare("twitterNoAcces")
    }
    static var  TWITTER_MAX_LENGHT:String{
        return getStringByKeyFromShare("twitterMaxLenght")
    }
    static var  TWITTER_MAX_SIZE:String{
        return getStringByKeyFromShare("twitterMaxSize")
    }
    static var  INSTAGRAM_MAX_LENGHT:String{
        return getStringByKeyFromShare("instagramMaxLenght")
    }
    static var  SHARE_YOUR_VIDEO:String{
        return getStringByKeyFromShare("shareYourVideo")
    }
    static var  FTP_ERROR_UNAUTHORIZED:String{
        return getStringByKeyFromShare("ftpErrorUnauthorized")
    }
    static var  FTP_ERROR_HOST_UNREACHABLE:String{
        return getStringByKeyFromShare("ftpErrorUnauthorized")
    }
    static var  FTP_ERROR_FILE_NOT_FOUND:String{
        return getStringByKeyFromShare("ftpErrorFileNotFound")
    }
    static var  FTP_INPUT_FILENAME_PLACEHOLDER:String{
        return getStringByKeyFromShare("ftpInputFilenamePlaceholder")
    }
    static var  FTP_INPUT_FILENAME_TITLE:String{
        return getStringByKeyFromShare("ftpInputFilenameTitle")
    }
    static var  FTP_INPUT_FILENAME_SAVE:String{
        return getStringByKeyFromShare("ftpInputFilenameSave")
    }
    static var  FTP_INPUT_FILENAME_CANCEL:String{
        return getStringByKeyFromShare("ftpInputFilenameCancel")
    }
    static var  EXPORT_FAILED_TITLE:String{
        return getStringByKeyFromShare("videoExportFailedTitle")
    }
    static var  EXPORT_FAILED_MESSAGE:String{
        return getStringByKeyFromShare("videoExportFailedMessage")
    }
    private static func getStringByKeyFromShare(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "Share")
    }
}
