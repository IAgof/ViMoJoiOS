//
//  ProjectListViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class ProjectListViewController:ViMoJoController{
    var eventHandler: ProjectListPresenterInterface?
    let reuseIdentifierCell = "projectListCell"
  
    var items :[ProjectListViewModel] = []

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithBackButton()
    }
    override func pushBack() {
        eventHandler?.pushBack()
    }
}

extension ProjectListViewController:ProjectListPresenterDelegate{
    func reloadTableData() {
        tableView.reloadData()
    }
        
    func setItems(_ items: [ProjectListViewModel]) {
        self.items = items
    }
}

//MARK: - UITableview datasource
extension ProjectListViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: reuseIdentifierCell, for: indexPath) as! ProjectListViewCell
        let itemNumber = indexPath.item
        let item = self.items[itemNumber]
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.date
        cell.durationLabel.text = item.duration
        cell.thumbnailImageView.image = item.thumbImage
        
        cell.editProjectButton.addTarget(self, action: #selector(pushEditProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.removeProjectButton.addTarget(self, action: #selector(pushRemoveProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.shareProjectButton.addTarget(self, action: #selector(pushShareProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.duplicateProjectButton.addTarget(self, action: #selector(pushDuplicateProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        
        cell.editProjectButton.tag = itemNumber
        cell.removeProjectButton.tag = itemNumber
        cell.shareProjectButton.tag = itemNumber
        cell.duplicateProjectButton.tag = itemNumber
        
        return cell
    }

}

extension ProjectListViewController{
    @IBAction func pushEditProjectButton(sender:UIButton){
        eventHandler?.editProject(projectNumber: sender.tag)
    }
    
    @IBAction func pushRemoveProjectButton(sender:UIButton){
        eventHandler?.removeProject(projectNumber: sender.tag)
    }
    
    @IBAction func pushShareProjectButton(sender:UIButton){
        eventHandler?.shareProject(projectNumber: sender.tag)
    }
    
    @IBAction func pushDuplicateProjectButton(sender:UIButton){
        eventHandler?.duplicateProject(projectNumber: sender.tag)
    }
}
extension ProjectListViewController:UITableViewDelegate{
    
    //MARK: - UITableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.editProject(projectNumber: indexPath.item)
    }
}
