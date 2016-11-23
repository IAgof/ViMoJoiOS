//
//  FTPErrorType.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


enum FTPErrorType:Int {
    case ftp_ERROR_HOST_UNREACHABLE = 60
    case ftp_ERROR_UNAUTHORIZED = 200
    case ftp_ERROR_NO_DOMAIN = 12
    case ftp_ERROR_FILE_NOT_FOUND = 2
    case ftp_ERROR_IO = 50
}
