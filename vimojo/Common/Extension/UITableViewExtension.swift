//
//  UITableViewExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension UITableView{
    func reloadDataMainThread(){ DispatchQueue.main.async { self.reloadData() } }
}
