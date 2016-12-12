//
//  DrawerMenuTableViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 1/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import KYDrawerController

class DrawerMenuTableViewController: UITableViewController {
    var eventHandler:DrawerMenuPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.didSelectAtIndexPath(indexPath: indexPath)
    }
    
    @IBAction func exitButtonPushed(_ sender: Any) {
        eventHandler?.exitPushed()
    }

}

extension DrawerMenuTableViewController: DrawerMenuPresenterDelegate{
    func closeDrawer(){
        if let parentController = (self.parent as? KYDrawerController){
           parentController.setDrawerState(.closed, animated: true)
        }
    }
}

//extension DrawerMenuTableViewController:KYDrawerControllerDelegate{
//    func drawerController(_ drawerController: KYDrawerController, stateChanged state: KYDrawerController.DrawerState) {
//        self.loadView()
//    }
//}
