//
//  FavoriteViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class FavoriteViewModel : BaseViewModel{
    let dbManager: DataManager
    let trackRepo: TracksRepositoryProtocol
    var tracks = Observable<[Result]?> (nil)
    var selectedIndex = Observable<Result?>(nil)
    private var cellViewModel = [TrackCellViewModel]() {
           didSet{
               observState?.value = .reloading
           }
       }
     var numberOfCells : Int {
        return cellViewModel.count
    }
    
    init(dbManager: DataManager = RealmDataManager()) {
        self.dbManager = dbManager
        self.trackRepo = TrackDataRepository(dbManager: dbManager)
    }
    
    
    func toggleTrackFromFavourite(trackObject : Result) {
        
       if checkIsTrackExist(track: trackObject) { trackRepo.deleteTrack(track: trackObject)}
       else { trackRepo.saveTrack(track: trackObject)}
       getAllTracks()
    }
    
  
    func deleteAllNews() {
        trackRepo.deleteAll()
    }
    
    
    
    func getAllTracks() {
        self.observState?.value = .loading
        trackRepo.getAllTracks(on: Sorted(key: "trackName", ascending: true)) { (tracks) in
            self.tracks.value = tracks
            self.createCellsViewModels(items:tracks)
            self.observState?.value = .populated
            print(tracks.count)
            
        }
    }
    
    func checkIsTrackExist(track:Result) -> Bool {
        return trackRepo.checkIsTrackExist(track: track)
        
    }
     func getCellViewModel(at indexPath: IndexPath) -> TrackCellViewModel? {
           return cellViewModel[indexPath.row]
       }
       
       
       
        func createCellsViewModels(items tracks:[Result]){
           cellViewModel.removeAll()
           for t in tracks {
            let tracksChecker = checkTrackIsExist(track: t)
            let checkInListAlready = checkFavoriteInList(track: t)
           
            if tracksChecker && !checkInListAlready {
                self.cellViewModel.append(TrackCellViewModel(track: t, isFavotite: tracksChecker))
            }
            self.observState?.value = .populated           }
       }
   
    
    func checkFavoriteInList(track:Result) -> Bool{
        let trackCellVM = TrackCellViewModel(track: track)
        return cellViewModel.contains {
            $0.trackName  == trackCellVM.trackName
        }
    }
    
    func deleteNewsAt(at indexPath :IndexPath) {
        let index = indexPath.row
        let track = tracks.value?[index]
        
        print(index)
        tracks.value?.remove(at: index)
        cellViewModel.remove(at: index)
        toggleTrackFromFavourite(trackObject: track!)
        self.observState?.value = .reloading
    }
    private func checkTrackIsExist(track:Result) -> Bool {
        return trackRepo.checkIsTrackExist(track: track)
    }
    
    func getTrack(for index: Int) -> Result?{
        return tracks.value?[index]
    }
}
