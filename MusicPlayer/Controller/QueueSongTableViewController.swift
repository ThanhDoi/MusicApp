//
//  QueueSongTableViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/13/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class QueueSongTableViewController: UITableViewController {
    
    var isSearching = false
    var filteredSongs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearching {
            return AudioPlayer.shared.queueSongs.count
        } else {
            return filteredSongs.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueSongCell", for: indexPath) as! QueueSongTableViewCell
        
        // Configure the cell...
        let song: Song
        if !isSearching {
            song = AudioPlayer.shared.queueSongs[indexPath.row]
        } else {
            song = filteredSongs[indexPath.row]
        }
        cell.songImage.image = UIImage(data: song.artwork!)
        cell.titleLabel.text = song.title
        cell.artistLabel.text = song.artist
        cell.backgroundColor = UIColor.white
        if indexPath.row == AudioPlayer.shared.counter {
            cell.backgroundColor = UIColor.lightGray
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSearching {
            AudioPlayer.shared.counter = indexPath.row
        } else {
            let song = filteredSongs[indexPath.row]
            AudioPlayer.shared.counter = AudioPlayer.shared.queueSongs.index(where: {(song1: Song) -> Bool in
                song1.title == song.title})!
            isSearching = false
        }
        AudioPlayer.shared.playSong()
        AudioPlayer.shared.playingVC?.updateInfo()
        tableView.reloadData()
    }
}
