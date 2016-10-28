//
//  FTPErrorType.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


enum FTPErrorType:Int {
    case FTP_ERROR_HOST_UNREACHABLE = 60
    case FTP_ERROR_UNAUTHORIZED = 200
    case FTP_ERROR_NO_DOMAIN = 12
    case FTP_ERROR_FILE_NOT_FOUND = 2
    case FTP_ERROR_IO = 50
}