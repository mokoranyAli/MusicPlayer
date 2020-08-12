//
//  Favorite + Delegate.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import UIKit
extension FavoriteViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoritViewModel.numberOfCells == 0 {
            collectionView.setEmptyView(title: "NO FAVORITES", message: "no favorite tracks to show")
        }
        else {
            collectionView.restore()
        }
        return favoritViewModel.numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)", for: indexPath ) as! ITunesTrackCollectionViewCell
        let cellVM = favoritViewModel.getCellViewModel(at: indexPath)
        cell.trackCellViewModel = cellVM
        cell.playButtonDelegate = self
        cell.favoriteDelegate = self
        cell.shareButtonDelegate = self
        cell.indexPath = indexPath
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (favoriteCollectionView.frame.width) / 2.1
        let height = favoriteCollectionView.frame.height/3
        //     print("layout collectionViewLayout")
        return CGSize(width: width, height: height)
    }
    
    
}

