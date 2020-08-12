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
        let cellVM = viewModel.getCellViewModel(at: indexPath)
               cell.trackCellViewModel = cellVM
        
        cell.playButtonDelegate = self
        cell.favoriteDelegate = self
        cell.shareButtonDelegate = self
        cell.indexPath = indexPath
       
        return cell
    }


 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
 {
     let width = (tracksCollectionView.frame.width) / 2
     let height = tracksCollectionView.frame.height/3
//     print("layout collectionViewLayout")
     return CGSize(width: width, height: height)
 }

    
    
    
}


