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
    let duration:String
    let imageURL:URL
    var isFavorite:Bool = false
    
    init(track:Result) {
        trackName = track.trackName ?? "NO NAME"
    
        let duraionObject = (track.trackTimeMillis?.secondsToHoursMinutesSeconds())!
        duration = "\(duraionObject.0):\(duraionObject.1):\(duraionObject.2)"
       
        guard  let url = URL(string: track.artworkUrl60 ?? "") else {
            self.imageURL = URL(string: "www.google.com")!
            return
        }
        
        imageURL = url
    }
}

extension Int {
func secondsToHoursMinutesSeconds () -> (Int, Int, Int) {
  return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
}
}
