//
//  DrawerMenuPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol DrawerMenuPresenterInterface {
    func didSelectAtIndexPath(indexPath:IndexPath)
    func exitPushed()
}

protocol DrawerMenuPresenterDelegate {
    func closeDrawer()
}
