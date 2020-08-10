//
//  TracksViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class TracksViewModel:BaseViewModel {
    
    //MARK: - properties
    var tracks = Observable<[Result]?> (nil)
    var selectedTrack = Observable<Result?>(nil)
    var numberOfCells: Int {
        return cellViewModel.count
    }
    
    private var cellViewModel = [TrackCellViewModel]() {
        didSet{
            observState?.value = .reloading
        }
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
            self.cellViewModel.append(TrackCellViewModel(track: track))
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
    }
}
