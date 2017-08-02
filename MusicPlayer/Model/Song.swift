//
//  Song.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 6/21/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import Foundation

class Song {
    
    var title: String?
    var artist: String?
    var album: String?
    var songURL: URL?
    var artwork: Data?
    
    init(title: String, artist: String, album: String, songURL: URL, artwork: Data) {
        self.title = title
        self.artist = artist
        self.album = album
        self.songURL = songURL
        self.artwork = artwork
    }
}
