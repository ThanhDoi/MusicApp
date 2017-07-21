//
//  QueueSongTableViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/13/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class QueueSongTableViewController: UITableViewController {
    
    var playingVC: PlayingViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AudioPlayer.shared.queueSongs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "queueSongCell", for: indexPath) as! QueueSongTableViewCell

        // Configure the cell...
        cell.songImage.image = UIImage(data: AudioPlayer.shared.queueSongs[indexPath.row].artwork)
        cell.titleLabel.text = AudioPlayer.shared.queueSongs[indexPath.row].title
        cell.artistLabel.text = AudioPlayer.shared.queueSongs[indexPath.row].artist
        cell.backgroundColor = UIColor.white
        if indexPath.row == AudioPlayer.shared.counter {
            cell.backgroundColor = UIColor.lightGray
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.counter = indexPath.row
        AudioPlayer.shared.playSong()
        playingVC.updateInfo()
        tableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
