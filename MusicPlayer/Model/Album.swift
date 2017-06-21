//
//  Album.swift
//  MusicPlayer
//
//  Created by Thanh Doi on 6/21/17.
//  Copyright © 2017 Thanh Doi. All rights reserved.
//

import Foundation

class Album {
    var songs = [Song]()
    var name: String!
    
    init(name: String) {
        self.name = name
    }
    
    func appendSong(song: Song) {
        self.songs.append(song)
    }
}
