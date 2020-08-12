//
//  FavoriteViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit

class FavoriteViewController: BaseViewController {

    @IBOutlet weak var favoriteCollectionView: UICollectionView!
     var favoritViewModel = FavoriteViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        setubObservers(viewModel: favoritViewModel)
        favoritViewModel.getAllTracks()
    }


    func setupCollectionView() {
        
        let cell = UINib(nibName: "\(ITunesTrackCollectionViewCell.cellID)", bundle: nil)
        favoriteCollectionView.register(cell, forCellWithReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)")
        favoriteCollectionView.dataSource = self
        favoriteCollectionView.delegate = self
    }

    override func reloadTableView() {
        favoriteCollectionView.reloadData()
        
    }
}
