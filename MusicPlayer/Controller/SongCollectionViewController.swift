//
//  SongCollectionViewController.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 6/21/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "songCell"

var audioPlayer = AVAudioPlayer()

class SongCollectionViewController: UICollectionViewController {
    
    var songs = [Song]()
    var albums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Do any additional setup after loading the view.
        loadSong()
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSong() {
        
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        var songTitle, songArtist, songAlbum: String!
        var songArtwork: Data!
        
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath {
                let mySong = song.absoluteString
                
                if mySong.contains(".m4a") {
                    let avpItem = AVPlayerItem(url: song)
                    let commonMetadata = avpItem.asset.commonMetadata
                    for item in commonMetadata {
                        if item.commonKey == "title" {
                            songTitle = item.stringValue
                        }
                        if item.commonKey == "artist" {
                            songArtist = item.stringValue
                        }
                        if item.commonKey == "albumName" {
                            songAlbum = item.stringValue
                        }
                        if item.commonKey == "artwork" {
                            songArtwork = item.dataValue
                        }
                    }
                    songs.append(Song(title: songTitle, artist: songArtist, album: songAlbum, songURL: song, artwork: songArtwork))
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewCell
        switch currentTab {
        case 0:
            cell.songArtwork.image = UIImage(data: songs[indexPath.row].artwork)
            cell.songTitle.text = songs[indexPath.row].title
            cell.songArtist.text = songs[indexPath.row].artist
        default:
            cell.songArtwork.image = UIImage(data: songs[indexPath.row].artwork)
            cell.songTitle.text = songs[indexPath.row].title
            cell.songArtist.text = songs[indexPath.row].artist
        }
        
        
        // Configure the cell
        
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            let audioPath = songs[indexPath.row].songURL
            try audioPlayer = AVAudioPlayer(contentsOf: audioPath!)
            audioPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
