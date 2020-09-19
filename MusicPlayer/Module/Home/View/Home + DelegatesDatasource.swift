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
       return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)", for: indexPath ) as! ITunesTrackCollectionViewCell
        let cellVM = viewModel?.getCellViewModel(at: indexPath)
               cell.trackCellViewModel = cellVM
        
        cell.playButtonDelegate = self
        cell.favoriteDelegate = self
        cell.shareButtonDelegate = self
        cell.indexPath = indexPath
       
        return cell
    }
  func numberOfSections(in collectionView: UICollectionView) -> Int {
     if viewModel?.numberOfCells == 0 {
               collectionView.setEmptyView(title: "NO Result", message: "no tracks or artists with this name")
           }
           else {
               collectionView.restore()
           }
           return viewModel?.numberOfCells ?? 0
  }

 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
 {
  let width = (tracksCollectionView.frame.width)
     let height = tracksCollectionView.frame.height/4
//     print("layout collectionViewLayout")
     return CGSize(width: width, height: height)
 }

    
    
    
}


