//
//  TracksViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class TracksViewModel:BaseViewModel {
    var tracks = Observable<[Result]?> (nil)
    func initFetchVM(query:String) {
        observState?.value = .loading
        apiProtocol?.searchEverything(query: query, ComplitionHandler: { (result, error) in
            if let e = error {
                           print("error is .... \(e.localizedDescription)")
                           self.observState?.value = .error(error: e.localizedDescription)
                           return
                       }
            self.tracks.value = result?.results
            print("number of tracks inside initVM TracksViewModel is \(result?.results?.count ?? 0)")
            self.observState?.value = .populated
        })
    }
    
    
    
}
