//
//  Musics.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import Foundation

import Foundation

// MARK: - Welcome
struct ResponseResult:Codable {
    var resultCount: Int?
    var results: [Result]?
}

// Result.swift

import Foundation

// MARK: - Result
struct Result:Codable {
    var wrapperType, kind: String?
    var artistId, collectionId, trackId: Int?
    var artistName, collectionName, trackName, collectionCensoredName: String?
    var trackCensoredName: String?
    var artistViewUrl, collectionViewUrl, trackViewUrl: String?
    var previewUrl: String?
    var artworkUrl30, artworkUrl60, artworkUrl100: String?
    var collectionPrice, trackPrice: Double?
    var releaseDate, collectionExplicitness, trackExplicitness: String?
    var discCount, discNumber, trackCount, trackNumber: Int?
    var trackTimeMillis: Int?
    var country, currency, primaryGenreName: String?
    var isStreamable: Bool?
    var collectionArtistID: Int?
    var collectionArtistName, contentAdvisoryRating: String?
    
}


