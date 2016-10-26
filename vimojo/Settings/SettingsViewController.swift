//
//  SettingsViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: ViMoJoController,SettingsInterface ,
    UINavigationBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var eventHandler: SettingsPresenterInterface?
    
    let reuseIdentifierCell = "settingsCell"
    
    //MARK: - List variables
    var sections = Array<String>()
    var items :[[SettingsViewModel]] = [[]]
    
    //MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var settingsNavBar: UINavigationItem!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
  }
    //MARK: - Actions
    @IBAction func pushBackBarButton(sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    //MARK: - UITableview datasource
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableView.sectionIndexColor = UIColor.redColor()
        
        return self.sections[section]
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, 30)) //set these values as necessary
        returnedView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel(frame: CGRectMake(8, 0, tableView.bounds.size.width, 30))
        label.text = self.sections[section]
        label.textColor = VIMOJO_RED_UICOLOR
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sections.count
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.items[section].count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? =
            tableView.dequeueReusableCellWithIdentifier(reuseIdentifierCell)
        if (cell != nil)
        {
            cell = UITableViewCell(style: .Value1,
                                   reuseIdentifier: reuseIdentifierCell)
        }
        // Configure the cell...
        let item = self.items[indexPath.section][indexPath.item]
        
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.subtitle
        
        cell!.detailTextLabel?.adjustsFontSizeToFitWidth
        cell!.textLabel?.adjustsFontSizeToFitWidth
        
        return cell!
    }
    
    //MARK: - UITableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //cell push
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        eventHandler?.itemListSelected(indexPath)
    }
}


extension SettingsViewController:SettingsPresenterDelegate{
    //MARK: - init view
    func registerClass(){
        settingsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifierCell)
    }
    
    func addFooter() {
        let footer = UINib(nibName: "VideonaFooterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        
        let footerTest = UIView.init(frame: footer.frame)
        footerTest.addSubview(footer)
        
        settingsTableView.tableFooterView = footerTest
    }
    
    func removeSeparatorTable() {
        settingsTableView.separatorStyle = .None
    }
    
    func setNavBarTitle(title:String){
        settingsNavBar.title = title
    }
    
    func reloadTableData() {
        settingsTableView.reloadData()
    }
    
    func setSectionsArray(sections: [String]) {
        self.sections = sections
    }
    
    func setItems(items: [[SettingsViewModel]]) {
        self.items = items
    }
}