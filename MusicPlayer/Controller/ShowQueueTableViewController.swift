//
//  ShowQueueTableViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/18/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class ShowQueueTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioPlayer.shared.queueSongs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueSongCell", for: indexPath) as! QueueSongTableViewCell
        cell.songImage.image = UIImage(data: AudioPlayer.shared.queueSongs[indexPath.row].artwork)
        cell.titleLabel.text = AudioPlayer.shared.queueSongs[indexPath.row].title
        cell.artistLabel.text = AudioPlayer.shared.queueSongs[indexPath.row].artist
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.counter = indexPath.row
        AudioPlayer.shared.playSong()
        AudioPlayer.shared.playingVC.updateInfo()
        AudioPlayer.shared.playingVC.queueSongVC.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.row != AudioPlayer.shared.counter {
                AudioPlayer.shared.queueSongs.remove(at: indexPath.row)
            } else {
                let message = UIAlertController(title: nil, message: "Cannot delete playing song", preferredStyle: UIAlertControllerStyle.alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                message.addAction(cancel)
                self.present(message, animated: true, completion: nil)
            }
        }
        tableView.reloadData()
        AudioPlayer.shared.playingVC.queueSongVC.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = AudioPlayer.shared.queueSongs[fromIndexPath.row]
        AudioPlayer.shared.queueSongs.remove(at: fromIndexPath.row)
        AudioPlayer.shared.queueSongs.insert(itemToMove, at: to.row)
        AudioPlayer.shared.counter = to.row
        tableView.reloadData()
        AudioPlayer.shared.playingVC.queueSongVC.tableView.reloadData()
        AudioPlayer.shared.playingVC.updateInfo()
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
