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


import RealmSwift
final class TrackRealm:Object {
    @objc dynamic var wrapperType:String = ""
    @objc dynamic var kind:String = ""
    @objc dynamic var artistId:Int = 0
    @objc dynamic var collectionId:Int = 0
    @objc dynamic var trackId:Int = 0
    @objc dynamic var artistName:String = ""
    @objc dynamic var collectionName:String = ""
    @objc dynamic var trackName:String = ""
    @objc dynamic var collectionCensoredName:String = ""
    @objc dynamic var trackCensoredName:String = ""
    
    @objc dynamic var artistViewUrl:String = ""
    @objc dynamic var collectionViewUrl:String = ""
    @objc dynamic var trackViewUrl:String = ""
    @objc dynamic var previewUrl:String = ""
    
    @objc dynamic var artworkUrl30:String = ""
    @objc dynamic var artworkUrl60:String = ""
    @objc dynamic var artworkUrl100:String = ""
      @objc dynamic var  trackTimeMillis: Int = 0


    override static func primaryKey() -> String? {
        return "previewUrl"
    }

}

extension Result  {
  /*static func mapFromPersistenceObject(_ object: NewsRealm) -> News {
    return News(source: SourceNews(id: object.sourceNewsID, name: object.sourceNewsName), author: object.author, title: object.title, articleDescription: object.articleDescription, url: object.url, urlToImage: object.urlToImage, publishedAt: object.publishedAt, content: object.content)
  } */
  
 

  typealias PersistenceType = TrackRealm
  func mapToPersistenceObject() -> PersistenceType {
    
    let track = TrackRealm()
    track.artistId = artistId ?? 0
    track.wrapperType = wrapperType ?? ""
    track.kind = kind ?? ""
    track.artistName = artistName ?? ""
    track.artistViewUrl = artistViewUrl ?? ""
    track.artworkUrl100 = artworkUrl100 ?? ""
    track.artworkUrl30 = artworkUrl30 ?? ""
    track.artworkUrl60 = artworkUrl60 ?? ""
    track.collectionCensoredName = collectionCensoredName ?? ""
    track.collectionId = collectionId ?? 0
    track.collectionName = collectionName ?? ""
    track.collectionViewUrl = collectionViewUrl ?? ""
    track.previewUrl = previewUrl ?? ""
    track.trackId = trackId ?? 0
    track.trackName = trackName ?? ""
    track.trackViewUrl = trackViewUrl ?? ""
    track.trackTimeMillis = trackTimeMillis ?? 0
    

    
    return track
  }
  
  
  
}
extension TrackRealm{
    func mapFromPersistenceObject() -> Result {
        return Result(wrapperType: self.wrapperType, kind: self.kind, artistId: self.artistId, collectionId: self.collectionId, trackId: self.trackId, artistName: self.artistName, collectionName: self.collectionName, trackName: self.trackName, collectionCensoredName: self.collectionCensoredName, trackCensoredName: self.trackCensoredName, artistViewUrl: self.artistViewUrl, collectionViewUrl: self.collectionViewUrl, trackViewUrl: self.trackViewUrl, previewUrl: self.previewUrl, artworkUrl30: self.artworkUrl30, artworkUrl60: self.artworkUrl60, artworkUrl100: self.artworkUrl100, collectionPrice: 0.0, trackPrice: 0.0, releaseDate: "", collectionExplicitness: "", trackExplicitness: "", discCount: 0, discNumber: 0, trackCount: 0, trackNumber: 0, trackTimeMillis: self.trackTimeMillis, country: "", currency: "", primaryGenreName: "", isStreamable: false, collectionArtistID: 0, collectionArtistName: "", contentAdvisoryRating: "")
    }
}
