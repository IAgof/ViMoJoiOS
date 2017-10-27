//
//  MusicViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

class MusicViewController: EditingRoomItemController, MusicPresenterDelegate, PlayerViewSetter, FullScreenWireframeDelegate {
    // MARK: - VIPER variables
    var eventHandler: MusicPresenterInterface?

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var addFloatingButton: UIButton!
	
    // MARK: - Variables and constants
    let cellIdentifier = "musicCell"
    var detailMusicView: MusicDetailView?
    var musicListView: MusicListView?
    var audios: [MusicSelectorCellViewModel] = [] {
        didSet {
            self.tableView.backgroundColor = .gray
            self.tableView.reloadDataMainThread()
        }
    }
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        eventHandler?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        eventHandler?.viewWillAppear()
        configureNavigationBarWithDrawerAndOptions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventHandler?.viewWillAppear()
        playerView.layoutSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }

    // MARK: Actions
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
	
	@IBAction func pushAddFloatingButton(_ sender: Any) {
		eventHandler?.pushAddFloating()
	}

    override func pushOptions() {
        eventHandler?.pushOptions()
    }

    // MARK: Interface
    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }

    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }

    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }

    // MARK: Private functions
    func configureTable() {
        tableView.register(UINib(nibName: MuiscSelectorTableViewCell.nibName, bundle: Bundle(for: MuiscSelectorTableViewCell.self)), forCellReuseIdentifier: MuiscSelectorTableViewCell.reusableIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
	
	func createAlertWithAddOptions(title: String,
	                               options: [String]) {
		
		let alertController = SettingsUtils().createActionSheetWithOptions(title,
		                                                                   options: options,
		                                                                   completion: {
																			response in
																			print("response add options")
																			print(response)
																			self.eventHandler?.addSelection(selection: response)
																			
		})
		alertController.setTintColor()
		
		if let popoverController = alertController.popoverPresentationController {
			popoverController.sourceView = addFloatingButton
		}
		self.present(alertController, animated: true, completion: nil)
		
	}
}

extension MusicViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MuiscSelectorTableViewCell.reusableIdentifier) as? MuiscSelectorTableViewCell else { return UITableViewCell()}

        let audio = audios[indexPath.item]
        cell.setup(with: audio)
        cell.tap = {
            self.tableView.reloadDataMainThread()
            //TODO: may be delete this?
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
        return cell
    }
}
