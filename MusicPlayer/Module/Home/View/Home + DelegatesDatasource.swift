//
//  Home + DelegatesDatasource.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import UIKit
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)", for: indexPath ) as! ITunesTrackCollectionViewCell
        cell.indexPath = indexPath
        cell.playButtonDelegate = self
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.trackCellViewModel = cellVM
        return cell
    }


 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
 {
     let width = (tracksCollectionView.frame.width) / 2
     let height = tracksCollectionView.frame.height/3
     print("layout collectionViewLayout")
     return CGSize(width: width, height: height)
 }

    
}


extension HomeViewController : playButtonClickable {
    func didClickedOnSourceLabel(at cell: ITunesTrackCollectionViewCell) {
//        let track =   viewModel.getTrack(for: cell.indexPath!.item)
//        print(track?.trackName)\
        if let index = cell.indexPath?.item {
            viewModel.didSelectedTrackToPlay(index: index)
        }
    }
    
    
}
