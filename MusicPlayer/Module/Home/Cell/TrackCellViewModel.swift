//
//  TrackCellViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation


struct TrackCellViewModel {
    let trackName:String
    var duration:String
    let imageURL:URL
    var isFavorite:Bool = false
    
    init(track:Result) {
        trackName = track.trackName ?? "NO NAME"
    duration = "A"
        // FIXME:- GUARD LET
        if  let duraionObject = (track.trackTimeMillis?.secondsToMinutesSeconds()) {
            duration = String(duraionObject)
//            print(track.trackTimeMillis!)
//            print(<#T##items: Any...##Any#>)
        }
        
       
        guard  let url = URL(string: track.artworkUrl60 ?? "") else {
            self.imageURL = URL(string: "www.google.com")!
            return
        }
        
        imageURL = url
    }
    
    init(track:Result , isFavotite:Bool) {
        self.init(track: track)
        self.isFavorite = isFavotite
    }
}

extension Int {
func secondsToMinutesSeconds () -> Double {
    return Double(self/1000/60)
}
}
