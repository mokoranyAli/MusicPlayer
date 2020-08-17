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
    var favoritViewModel:FavoriteViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        setubObservers(viewModel: favoritViewModel!)
        favoritViewModel?.getAllTracks()
        setupTrackDidSelectedToPlay()
        self.tabBarController?.tabBar.isHidden = true
        //        print(tabBarController)
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
    
    //MARK: -setup did select track
    private func setupTrackDidSelectedToPlay() {
        
        favoritViewModel?.playList.subscribe({[unowned self] (playListWithCurrentIndex) in
            if let plistWithCurrent = playListWithCurrentIndex {
                self.showPlayerScreen(playlist: plistWithCurrent.0, currentTrackIndex: plistWithCurrent.1)
            }
        })
    }
    
    //MARK: - ShowPlayerScreen
    func showPlayerScreen(playlist:[Result] , currentTrackIndex:Int) {
        
        
        let popupContentController = PlayerViewController(nibName: "\(PlayerViewController.self)", bundle: nil) as PlayerViewController
        popupContentController.playList = playlist
        popupContentController.currentTrackIndex = currentTrackIndex
        self.tabBarController?.popupBar.barStyle = .compact
        popupContentController.songTitle = playlist[currentTrackIndex].trackName!
        popupContentController.artistName = playlist[currentTrackIndex].artistName!
        popupContentController.playerDelegate = self
        //self.tabBarController?.navigationController?.navigationBar.isHidden = true
        
        tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
        self.tabBarController?.presentPopupBar(
            withContentViewController: popupContentController,
            openPopup: true,
            animated: true,
            completion: nil
        )
        
        
        
        if #available(iOS 13.0, *) {
            self.tabBarController?.popupBar.tintColor = .orange
        } else {
            self.tabBarController?.popupBar.tintColor = .orange
        }
        
    }
    
    
}

