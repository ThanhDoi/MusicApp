//
//  MainViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 5/22/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

enum tabSelecting: Int {
    case songs = 0
    case albums
    case artists
}

var currentTab: Int = 0

class MainViewController: UIViewController {
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songTypeButton: UIButton!
    @IBOutlet weak var songView: UIView!
    
    // Progress View
    @IBOutlet weak var playingSlider: UISlider!
    @IBOutlet weak var playingSongImage: UIImageView!
    @IBOutlet weak var playingSongName: UILabel!
    @IBOutlet weak var playingSongArtist: UILabel!
    @IBOutlet weak var playingSongPauseButton: UIButton!
    
    var isListView = true
    var songCollectionViewController: SongCollectionViewController!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = 100
        }
        configureSearchController()
        AudioPlayer.shared.mainVC = self
        NotificationCenter.default.addObserver(self, selector: #selector(rearMenuClick(_:)), name: NSNotification.Name(rawValue: rearMenuClicked), object: nil)
        setupNowPlayingInfoCentre()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    func updateInfo() {
        let playingSong = AudioPlayer.shared.queueSongs[AudioPlayer.shared.counter]
        self.playingSongName.text = playingSong.title
        self.playingSongArtist.text = playingSong.artist
        self.playingSongImage.image = UIImage(data: playingSong.artwork)
        self.playingSlider.maximumValue = Float(TimeInterval(AudioPlayer.shared.player.duration))
        self.playingSlider.setValue(0, animated: true)
        if AudioPlayer.shared.player.isPlaying {
            self.playingSongPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            self.playingSongPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    // MARK: Search function
    
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
    
    func getSearchResult(searchString: String) {
        if searchController.isActive && searchController.searchBar.text != "" {
            songCollectionViewController.isSearching = true
            songCollectionViewController.filteredSongs = songCollectionViewController.songs.filter { song in
                return song.title.lowercased().contains(searchString.lowercased())
            }
            songCollectionViewController.filteredAlbums = songCollectionViewController.albums.filter { album in
                return album.name.lowercased().contains(searchString.lowercased())
            }
            songCollectionViewController.filteredArtists = songCollectionViewController.artists.filter { artist in
                return artist.name.lowercased().contains(searchString.lowercased())
            }
        } else {
            songCollectionViewController.isSearching = false
        }
        songCollectionViewController.collectionView?.reloadData()
    }
    
    @IBAction func songTypeButtonAction(_ sender: Any) {
        if isListView {
            songTypeButton.setImage(UIImage(named: "grid"), for: .normal)
        } else {
            songTypeButton.setImage(UIImage(named: "list"), for: .normal)
        }
        isListView = !isListView
        songCollectionViewController.listButtonClicked(isListView: isListView)
    }
    
    @IBAction func pauseButtonAction(_ sender: Any) {
        if let audioPlayer = AudioPlayer.shared.player {
            if audioPlayer.isPlaying {
                playingSongPauseButton.setImage(UIImage(named: "play"), for: .normal)
                AudioPlayer.shared.pauseSong()
            } else {
                playingSongPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                AudioPlayer.shared.resumeSong()
            }
        }
    }
    
    // MARK: Slider function
    
    @IBAction func changePlayingTime(_ sender: Any) {
        AudioPlayer.shared.player.currentTime = TimeInterval(playingSlider.value)
    }
    
    func setTimer() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updatePlayingTime), userInfo: nil, repeats: true)
    }
    
    func updatePlayingTime() {
        playingSlider.value = Float((AudioPlayer.shared.player.currentTime))
    }
    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    func rearMenuClick(_ notification: Notification) {
        let indexPath = notification.object as! IndexPath
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        self.collectionView.delegate?.collectionView!(self.collectionView, didSelectItemAt: indexPath)
    }
    
    func setupNowPlayingInfoCentre() {
        try! AVAudioSession.sharedInstance().setActive(true)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
        } catch {
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        MPRemoteCommandCenter.shared().playCommand.addTarget(handler: {event in
            AudioPlayer.shared.resumeSong()
            self.playingSongPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            AudioPlayer.shared.playingVC.pauseButton.setImage(UIImage(named: "pause"), for: .normal)
            return .success
        })
        MPRemoteCommandCenter.shared().pauseCommand.addTarget(handler: {event in
            AudioPlayer.shared.pauseSong()
            self.playingSongPauseButton.setImage(UIImage(named: "play"), for: .normal)
            AudioPlayer.shared.playingVC.pauseButton.setImage(UIImage(named: "play"), for: .normal)
            return .success
        })
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget(handler: {event in
            AudioPlayer.shared.playNextSong()
            return .success
        })
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget(handler: {event in
            AudioPlayer.shared.playPreviousSong()
            return .success
        })
    }
    
    @IBAction func showPlayingVCGesture(_ sender: Any) {
        performSegue(withIdentifier: "playingSongSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songEmbedSegue" {
            let vc = segue.destination as! SongCollectionViewController
            songCollectionViewController = vc
            songCollectionViewController.mainVC = self
        }
        
        if segue.identifier == "playingSongSegue" {
            let vc = segue.destination as! PlayingViewController
            AudioPlayer.shared.playingVC = vc
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        return CGSize(width: width/3, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index: tabSelecting = tabSelecting(rawValue: indexPath.row)!
        switch index {
        case .songs:
            currentTab = 0
            songCollectionViewController.collectionView?.reloadData()
            collectionView.reloadData()
        case .albums:
            currentTab = 1
            songCollectionViewController.collectionView?.reloadData()
            collectionView.reloadData()
        case .artists:
            currentTab = 2
            songCollectionViewController.collectionView?.reloadData()
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as!TabCollectionViewCell
        
        if indexPath.row == currentTab {
            cell.tabLabel.textColor = UIColor.red
        } else {
            cell.tabLabel.textColor = UIColor.white
        }
        cell.tabLabel.text = items[indexPath.row]
        cell.tabLabel.sizeToFit()
        cell.backgroundColor = UIColor.blue
        
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navView.isHidden = false
        self.searchView.isHidden = true
        self.titleLabel.text = "Beauty Music"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        self.titleLabel.text = text
        self.navView.isHidden = false
        self.searchController.searchBar.resignFirstResponder()
        self.searchView.isHidden = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
        if self.titleLabel.text != "Beauty Music" {
            songCollectionViewController.isSearching = true
            songCollectionViewController.collectionView?.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getSearchResult(searchString: searchController.searchBar.text!)
    }
}
