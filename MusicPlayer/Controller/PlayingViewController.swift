//
//  PlayingViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/13/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit

class PlayingViewController: UIViewController {
    
    var queueSongVC: QueueSongTableViewController?
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistTitle: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playingProgress: UISlider!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    var timer: Timer!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        updateInfo()
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updatePlayingTime), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func convertToTime(time: Float) -> String {
        let minute = String(format: "%.0f", floor(time / 60))
        let second = String(format: "%.0f", time.truncatingRemainder(dividingBy: 60))
        return minute + ":" + second
    }
    
    func updatePlayingTime() {
        playingProgress.value = Float(AudioPlayer.shared.player.currentTime)
        timeLabel.text = convertToTime(time: Float(AudioPlayer.shared.player.currentTime))
    }
    @IBAction func changePlayingTime(_ sender: Any) {
        AudioPlayer.shared.player.currentTime = TimeInterval(playingProgress.value)
    }
    
    func updateInfo() {
        songTitle.text = AudioPlayer.shared.queueSongs[AudioPlayer.shared.counter].title
        artistTitle.text = AudioPlayer.shared.queueSongs[AudioPlayer.shared.counter].artist
        playingProgress.maximumValue = Float(AudioPlayer.shared.player.duration)
        if AudioPlayer.shared.player.isPlaying {
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        playingProgress.setValue(0, animated: true)
        queueSongVC?.tableView.reloadData()
        let index = IndexPath(row: AudioPlayer.shared.counter, section: 0)
        queueSongVC?.tableView.scrollToRow(at: index, at: UITableViewScrollPosition.middle, animated: true)
    }
    
    @IBAction func previousButtonPress(_ sender: Any) {
        AudioPlayer.shared.playPreviousSong()
    }
    
    @IBAction func nextButtonPress(_ sender: Any) {
        AudioPlayer.shared.playNextSong()
    }
    
    @IBAction func shuffleButtonPress(_ sender: Any) {
        AudioPlayer.shared.isShuffle = !AudioPlayer.shared.isShuffle
        if AudioPlayer.shared.isShuffle {
            shuffleButton.setImage(UIImage(named: "shuffleon"), for: .normal)
        } else {
            shuffleButton.setImage(UIImage(named: "shuffleoff"), for: .normal)
        }
    }
    
    @IBAction func repeatButtonPress(_ sender: Any) {
        AudioPlayer.shared.isRepeat = !AudioPlayer.shared.isRepeat
        if AudioPlayer.shared.isRepeat {
            repeatButton.setImage(UIImage(named: "repeaton"), for: .normal)
        } else {
            repeatButton.setImage(UIImage(named: "repeatoff"), for: .normal)
        }
    }
    
    @IBAction func pauseButtonPress(_ sender: Any) {
        if let audioPlayer = AudioPlayer.shared.player {
            if audioPlayer.isPlaying {
                pauseButton.setImage(UIImage(named: "play"), for: .normal)
                AudioPlayer.shared.mainVC?.playingSongPauseButton.setImage(UIImage(named: "play"), for: .normal)
                AudioPlayer.shared.pauseSong()
            } else {
                pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                AudioPlayer.shared.mainVC?.playingSongPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                AudioPlayer.shared.resumeSong()
            }
        }
    }
    
    @IBAction func musicListButtonPress(_ sender: Any) {
        performSegue(withIdentifier: "showQueueSong", sender: self)
    }
    
    // MARK: Search functions
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchView.addSubview(searchController.searchBar)
        searchView.isHidden = true
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        navView.isHidden = true
        searchView.isHidden = false
    }
    
    func getSearchResults(searchString: String) {
        if searchController.isActive && searchController.searchBar.text != "" {
            queueSongVC?.isSearching = true
            queueSongVC?.filteredSongs = AudioPlayer.shared.queueSongs.filter { song in
                return (song.title?.lowercased().contains(searchString.lowercased()))!
            }
        } else {
            queueSongVC?.isSearching = false
        }
        queueSongVC?.tableView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "queueSongSegue" {
            let vc = segue.destination as! QueueSongTableViewController
            queueSongVC = vc
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    }
}

extension PlayingViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navView.isHidden = false
        self.searchView.isHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navView.isHidden = false
        self.searchController.searchBar.resignFirstResponder()
        self.searchView.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
}

extension PlayingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getSearchResults(searchString: searchController.searchBar.text!)
    }
}
