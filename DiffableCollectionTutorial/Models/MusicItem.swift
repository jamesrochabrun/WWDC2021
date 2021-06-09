//
//  MusicItem.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Foundation

/**
 {
 "artistName": "Polo G",
 "id": "1569244974",
 "releaseDate": "2021-06-11",
 "name": "Hall of Fame",
 "kind": "album",
 "copyright": "℗ 2021 Columbia Records, a Division of Sony Music Entertainment",
 "artistId": "1159371412",
 "contentAdvisoryRating": "Explicit",
 "artistUrl": "https://music.apple.com/us/artist/polo-g/1159371412?app=music",
 "artworkUrl100": "https://is3-ssl.mzstatic.com/image/thumb/Music125/v4/80/ed/d5/80edd537-0a27-6c17-d73f-cdc07d1dc953/886449331611.jpg/200x200bb.png",
 "genres": [
 {
 "genreId": "18",
 "name": "Hip-Hop/Rap",
 "url": "https://itunes.apple.com/us/genre/id18"
 },
 {
 "genreId": "34",
 "name": "Music",
 "url": "https://itunes.apple.com/us/genre/id34"
 }
 ],
 "url": "https://music.apple.com/us/album/hall-of-fame/1569244974?app=music"
 }
 */

struct MusicItem: Decodable {
    let artworkUrl100: String
    let artistName: String
    let copyright: String?
}


struct MusicItemViewModel: IdentifiableHashable {
    let id = UUID()
    let musicItem: MusicItem
    var mainTitle: String { musicItem.artistName }
    var subTitle: String { musicItem.copyright ?? "No sub" }
    var artworkLarge: URL? { URL(string: musicItem.artworkUrl100) }
}
