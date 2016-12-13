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

    override func viewWillAppear(_ animated: Bool) {
            print("View will appear")
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
    
    func layoutDrawerControllerView() {
        if let parentController = parent as? KYDrawerController{
            parentController.mainViewController.viewWillAppear(true)
        }
    }
}

extension DrawerMenuTableViewController:KYDrawerControllerDelegate{
    func viewWillAppear() {
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? DrawerProfileTableViewCell{
            cell.configureView()
        }
    }
}
