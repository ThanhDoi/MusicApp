//
//  Artist.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 7/11/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import Foundation

class Artist {
    var name: String?
    var songs = [Song]()
    var albums = [Album]()
    
    init(name: String) {
        self.name = name
    }
    
    func appendSong(song: Song) {
        self.songs.append(song)
    }
    
    func appendAlbum(album: Album) {
        self.albums.append(album)
    }
}
