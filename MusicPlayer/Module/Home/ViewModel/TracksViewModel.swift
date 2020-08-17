//
//  TracksViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation

class TracksViewModel:BaseViewModel {
    
    var favoriteViewModel:FavoriteViewModel?
    
    //MARK: - properties
    var tracks = Observable<[Result]?> (nil)
    var selectedTrack = Observable<Result?>(nil)
    var playList = Observable<([Result] , Int)?>(nil)
    var selectedTrackToShare = Observable<Result?>(nil)
    var numberOfCells: Int {
        return cellViewModel.count
    }
    
    private var cellViewModel = [TrackCellViewModel](){
        didSet{
            observState?.value = .reloading
        }
    }
    
    init(favoriteViewModel:FavoriteViewModel) {
        super.init()
        self.favoriteViewModel = favoriteViewModel
    }
    
    /// helper functions
    
    //MARK: - fetch data from API
    func initFetchVM(query:String) {
        observState?.value = .loading
        apiProtocol?.searchEverything(query: query, ComplitionHandler: { (result, error) in
            guard let e = error  else {
                
                if let tracks = result?.results {
                    self.tracks.value = tracks
                    self.createCellsViewModels(items: tracks)
                }
                
                print("number of tracks inside initVM TracksViewModel is \(result?.results?.count ?? 0)")
                self.observState?.value = .populated
                return
            }
            
            print("error is .... \(e.localizedDescription)")
            self.observState?.value = .error(error: e.localizedDescription)
            
        })
    }
    
    private func createCellsViewModels(items tracks:[Result]){
        cellViewModel.removeAll()
        for track in tracks {
            let trackChecker = checkTrackIsExist(track: track)
            self.cellViewModel.append(TrackCellViewModel(track: track, isFavotite: trackChecker))
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> TrackCellViewModel? {
        return cellViewModel[indexPath.row]
    }
    
    
    func getTrack(for index: Int) -> Result?{
        return tracks.value?[index]
    }
    
    func didSelectedTrackToPlay(index:Int) {
        selectedTrack.value = tracks.value?[index]
        playList.value = (tracks.value , index) as! ([Result], Int)
    }
    
    func reloadCellViewModel(){
           if let track = tracks.value {
               createCellsViewModels(items: track)
           }
       }
    
    private func checkTrackIsExist(track:Result) -> Bool {
          return favoriteViewModel?.checkIsTrackExist(track: track) ?? false
      }

      
      
      func toggleFavortie(for track : Result) {
          favoriteViewModel?.toggleTrackFromFavourite(trackObject: track)
          reloadCellViewModel()
      }
      
      
      func getTrack(form indexPath: IndexPath) -> Result? {
          return tracks.value?[indexPath.row]
      }
    
    func shareItemOnIndexPath(index:Int) {
        guard let track = tracks.value?[index] else {return}
        self.selectedTrackToShare.value = track
        
    }

}
