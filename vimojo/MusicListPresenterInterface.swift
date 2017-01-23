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
    func pushOptions()
    func didSelectMusicAtIndexPath(_ indexPath:IndexPath)
    func cancelDetailButtonPushed()
    func acceptDetailButtonPushed()
    func removeDetailButtonPushed()
    func setMusicDetailInterface(_ eventHandler:MusicDetailInterface)

    func getMusicList()
    func updatePlayerLayer()
    func playerHasLoaded()

}

protocol MusicListPresenterDelegate {
    func setMusicList(_ list:[MusicViewModel])
    
    func showTableView()
    func hideTableView()
    
    func showDetailView(_ title:String,
                        author:String,
                        image:UIImage)
    func hideDetailView()
}
