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

class SongCollectionViewController: UICollectionViewController {
    
    var mainVC: MainViewController!
    
    let listFlowLayout = ListFlowLayout()
    let gridFlowLayout = GridFlowLayout()
    
    var songs = [Song]()
    var albums = [Album]()
    var artists = [Artist]()
    
    // Search Results
    var filteredSongs = [Song]()
    var filteredAlbums = [Album]()
    var filteredArtists = [Artist]()
    
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.setCollectionViewLayout(listFlowLayout, animated: true)
        loadSong()
        loadAlbum()
        loadArtist()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Load Songs, Albums, Artists
    
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
    
    func loadAlbum() {
        for eachSong in songs {
            var state = true
            for eachAlbum in albums {
                if eachAlbum.name == eachSong.album {
                    eachAlbum.appendSong(song: eachSong)
                    state = false
                }
            }
            if state == true {
                albums.append(Album(name: eachSong.album))
                albums.last?.appendSong(song: eachSong)
            }
        }
    }
    
    func loadArtist() {
        for eachSong in songs {
            var state = true
            for eachArtist in artists {
                if eachArtist.name == eachSong.artist {
                    eachArtist.appendSong(song: eachSong)
                    state = false
                }
            }
            if state == true {
                artists.append(Artist(name: eachSong.artist))
                artists.last?.appendSong(song: eachSong)
            }
        }
        
        for eachArtist in artists {
            for eachSong in eachArtist.songs {
                var state = true
                for eachAlbum in eachArtist.albums {
                    if eachAlbum.name == eachSong.album {
                        eachAlbum.appendSong(song: eachSong)
                        state = false
                    }
                }
                
                if state == true {
                    eachArtist.albums.append(Album(name: eachSong.album))
                    eachArtist.albums.last?.appendSong(song: eachSong)
                }
            }
        }
    }
    
    func listButtonClicked(isListView: Bool) {
        if isListView {
            collectionView?.collectionViewLayout.invalidateLayout()
            collectionView?.setCollectionViewLayout(listFlowLayout, animated: true)
        } else {
            collectionView?.collectionViewLayout.invalidateLayout()
            collectionView?.setCollectionViewLayout(gridFlowLayout, animated: true)
        }
        collectionView?.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentTab {
        case 0:
            if !isSearching {
                return songs.count
            } else {
                return filteredSongs.count
            }
        case 1:
            if !isSearching {
                return albums.count
            } else {
                return filteredAlbums.count
            }
        case 2:
            if !isSearching {
                return artists.count
            } else {
                return filteredArtists.count
            }
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SongCollectionViewCell
        switch currentTab {
        case 0:
            let song: Song
            if !isSearching {
                song = songs[indexPath.row]
            } else {
                song = filteredSongs[indexPath.row]
            }
            cell.songArtwork.isHidden = false
            cell.songArtwork.image = UIImage(data: song.artwork)
            cell.songTitle.isHidden = false
            cell.songTitle.text = song.title
            cell.songArtist.isHidden = false
            cell.songArtist.text = song.artist
        case 1:
            let album: Album
            if !isSearching {
                album = albums[indexPath.row]
            } else {
                album = filteredAlbums[indexPath.row]
            }
            cell.songArtwork.isHidden = false
            cell.songArtwork.image = UIImage(data: (album.songs.first?.artwork)!)
            cell.songTitle.isHidden = false
            cell.songTitle.text = album.songs.first?.album
            cell.songArtist.isHidden = true
        case 2:
            let artist: Artist
            if !isSearching {
                artist = artists[indexPath.row]
            } else {
                artist = filteredArtists[indexPath.row]
            }
            cell.songArtwork.isHidden = true
            cell.songTitle.isHidden = false
            cell.songTitle.text = artist.name
            cell.songArtist.isHidden = false
            var numberAlbum: String
            var numberSong: String
            if artist.albums.count == 1 {
                numberAlbum = String(artist.albums.count) + " album"
            } else {
                numberAlbum = String(artist.albums.count) + " albums"
            }
            if artist.songs.count == 1 {
                numberSong = String(artist.songs.count) + " song"
            } else {
                numberSong = String(artist.songs.count) + " songs"
            }
            cell.songArtist.text = numberAlbum + " | " + numberSong
        default:
            print("INVALID")
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentTab {
        case 0:
            let song: Song
            if !isSearching {
                song = songs[indexPath.row]
            } else {
                song = filteredSongs[indexPath.row]
            }
            AudioPlayer.shared.appendSong(song: song)
            AudioPlayer.shared.counter = 0
            AudioPlayer.shared.playSong()
            mainVC.performSegue(withIdentifier: "playingSongSegue", sender: mainVC)
        case 1:
            let toPlaySong: [Song]
            if !isSearching {
                toPlaySong = albums[indexPath.row].songs
            } else {
                toPlaySong = filteredAlbums[indexPath.row].songs
            }
            for eachSong in toPlaySong {
                AudioPlayer.shared.appendSong(song: eachSong)
            }
            AudioPlayer.shared.counter = 0
            AudioPlayer.shared.playSong()
            mainVC.performSegue(withIdentifier: "playingSongSegue", sender: mainVC)
        case 2:
            let toPlaySong: [Song]
            if !isSearching {
                toPlaySong = artists[indexPath.row].songs
            } else {
                toPlaySong = filteredArtists[indexPath.row].songs
            }
            for eachSong in toPlaySong {
                AudioPlayer.shared.appendSong(song: eachSong)
            }
            AudioPlayer.shared.counter = 0
            AudioPlayer.shared.playSong()
            mainVC.performSegue(withIdentifier: "playingSongSegue", sender: mainVC)
        default:
            print("INVALID")
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
