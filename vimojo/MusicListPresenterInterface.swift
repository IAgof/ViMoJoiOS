//
//  MusicListPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol MusicListPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
   
    func pushBackButton()
    func didSelectMusicAtIndexPath(indexPath:NSIndexPath)
    func cancelDetailButtonPushed()
    func acceptDetailButtonPushed()
    func removeDetailButtonPushed()
    func setMusicDetailInterface(eventHandler:MusicDetailInterface)

    func getMusicList()
    func updatePlayerLayer()

}

protocol MusicListPresenterDelegate {
    func setMusicList(list:[MusicViewModel])
    
    func showTableView()
    func hideTableView()
    
    func showDetailView(title:String,
                        author:String,
                        image:UIImage)
    func hideDetailView()
}