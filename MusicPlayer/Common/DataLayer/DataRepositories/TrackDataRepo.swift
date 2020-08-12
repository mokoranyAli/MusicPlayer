//
//  TrackDataRepo.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
protocol TracksRepositoryProtocol {
    
    //MARK: - Methods
    func getAllTracks(on sort: Sorted?,completionHandler: ([Result]) -> Void)
    func saveTrack(track: Result)
    func deleteTrack(track:Result)
    func deleteAll()
    func checkIsTrackExist(track:Result) -> Bool
}

//MARK: -  NewsRepository
class TrackDataRepository : BaseDataRepository<TrackRealm> {
    
}

extension TrackDataRepository : TracksRepositoryProtocol {
    
    
    func checkIsTrackExist(track:Result) -> Bool {
        do { return try dbManager.checkObjectIsExistInDB(TrackRealm.self, key: track.previewUrl!) }
        catch { print("error ....") }
        return false
    }
    
    
    func deleteAll() {
        do{ try   super.deleteAll(TrackRealm.self) }
        catch { print(error.localizedDescription) }
    }
    
    
    func getAllTracks(on sort: Sorted?, completionHandler: ([Result]) -> Void) {
        super.fetch(TrackRealm.self, sorted: sort) { (news) in
            completionHandler(news.map { $0.mapFromPersistenceObject() /*News.mapFromPersistenceObject($0)*/ } )
        }
    }
    
    
     func saveTrack(track: Result) {
        do { try super.save(object: track.mapToPersistenceObject()) }
        catch { print(error.localizedDescription) }
    }
    
    
    
    func deleteTrack(track:Result) {
        do{
            let trackWillDelete = try dbManager.getObject(TrackRealm.self, key: track.previewUrl!)
            print(trackWillDelete?.artistName ?? "h")
            if let news = trackWillDelete {
                try super.delete(object: news)
            }
        }
        catch {
            print("erorr ...... \(error.localizedDescription)")
        }
        
    }
    
    
}
