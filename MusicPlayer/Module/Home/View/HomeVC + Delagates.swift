//
//  HomeVC + Delagates.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation

extension HomeViewController:TrackRealmDelegate {
    func toggleFavotire(cell: ITunesTrackCollectionViewCell) {
        print("HomeViewController TrackRealmDelegate toggleFavotire")
        guard let index = cell.indexPath?.item else { return }
        if let trackObj = viewModel.getTrack(for: index){
            viewModel.toggleFavortie(for: trackObj)
        }
    }
   
}

extension HomeViewController : PlayButtonClickable {
    func didClickedOnPlayButton(at cell: ITunesTrackCollectionViewCell) {
        if let index = cell.indexPath?.item {
            viewModel.didSelectedTrackToPlay(index: index)
        }
    }
}

extension HomeViewController : SharButtonClickable {
    func didClickOnShareButton(at cell: ITunesTrackCollectionViewCell) {
        guard let index = cell.indexPath?.item else { return }
        viewModel.shareItemOnIndexPath(index:index)
    }
    
    
}
