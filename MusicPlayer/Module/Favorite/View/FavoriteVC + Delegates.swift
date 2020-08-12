//
//  FavoriteVC + Delegates.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
extension FavoriteViewController:TrackRealmDelegate {
    func toggleFavotire(cell: ITunesTrackCollectionViewCell) {
        print("HomeViewController TrackRealmDelegate toggleFavotire")
        guard let index = cell.indexPath?.item else { return }
        if let trackObj = favoritViewModel.getTrack(for: index){
            favoritViewModel.toggleTrackFromFavourite(trackObject: trackObj)
        }
    }
   
}

extension FavoriteViewController : PlayButtonClickable {
    func didClickedOnPlayButton(at cell: ITunesTrackCollectionViewCell) {
        if let index = cell.indexPath?.item {
            //favoritViewModel.didSelectedTrackToPlay(index: index)
        }
    }
}

extension FavoriteViewController : SharButtonClickable {
    func didClickOnShareButton(at cell: ITunesTrackCollectionViewCell) {
        guard let index = cell.indexPath?.item else { return }
//        viewModel.shareItemOnIndexPath(index:index)
    }
    
    
}
