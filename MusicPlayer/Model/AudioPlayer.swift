//
//  AudioPlayer.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/12/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioPlayer()
    
    var mainVC: MainViewController?
    var playingVC: PlayingViewController?
    var player: AVAudioPlayer!
    var counter = 0
    var isShuffle = false
    var isRepeat = false
    
    var queueSongs = [Song]()
    
    override private init() {
        super.init()
    }
    
    func playSong() {
        let audioPath = queueSongs[counter].songURL
        do {
            try player = AVAudioPlayer(contentsOf: audioPath!)
        } catch let error {
            print(error.localizedDescription)
        }
        player?.delegate = self
        player.prepareToPlay()
        player.play()
        updateInfoToMainVC()
        updateInfoMPNowPlaying()
    }
    
    func updateInfoToMainVC() {
        mainVC?.updateInfo()
        mainVC?.setTimer()
    }
    
    func updateInfoMPNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: queueSongs[counter].title,
            MPMediaItemPropertyArtist: queueSongs[counter].artist,
            MPMediaItemPropertyAlbumTitle: queueSongs[counter].album,
            MPMediaItemPropertyPlaybackDuration: player.duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player.currentTime,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: UIImage(data: queueSongs[counter].artwork!)!),
            MPNowPlayingInfoPropertyPlaybackRate: player.isPlaying ? 1 : 0
        ]
    }

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if !isRepeat {
            if isShuffle {
                shuffleSong()
            } else {
                playNextSong()
                playingVC?.updateInfo()
            }
        } else {
            playSong()
        }
    }
    
    func appendSong(song: Song) {
        if let index = self.queueSongs.index(where: {$0.title == song.title}) {
            self.queueSongs.remove(at: index)
        }
        self.queueSongs.insert(song, at: 0)
    }
    
    func playNextSong() {
        if !isShuffle {
            counter = counter + 1
            if counter == queueSongs.count {
                counter = 0
            }
            playSong()
            playingVC?.updateInfo()
        } else {
            shuffleSong()
        }
    }
    
    func playPreviousSong() {
        if !isShuffle {
            counter = counter - 1
            if counter == -1 {
                counter = queueSongs.count - 1
            }
            playSong()
            playingVC?.updateInfo()
        } else {
            shuffleSong()
        }
    }
    
    func pauseSong() {
        player.pause()
        updateInfoMPNowPlaying()
    }
    
    func resumeSong() {
        player.play()
        updateInfoMPNowPlaying()
    }
    
    func shuffleSong() {
        let random = arc4random_uniform(UInt32(queueSongs.count))
        counter = Int(random)
        playSong()
        playingVC?.updateInfo()
    }
}
