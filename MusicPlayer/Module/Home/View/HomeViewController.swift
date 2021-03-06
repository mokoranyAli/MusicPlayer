//
//  HomeViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import Kingfisher
import LNPopupController

class HomeViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    
    //MARK: - properties
    var searchController = UISearchController(searchResultsController: nil)
    var viewModel:TracksViewModel?
    var popupContentController:PlayerViewController?
    var currentSongInPlaying:Result?
    var trackImage:UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(searchController)
        print("Home VC")
        setupTrackDidSelectedToPlay()
        setupLayoutForCollectionView()
        setupCollectionView()
        setubObservers(viewModel: viewModel!)
        setupSearchController()
        setupSelectedTrackToShare()
        viewModel?.initFetchVM(query: "adele")
    }
    
    
    
    
    
    //MARK: -setup reloading Collection View
    override func reloadTableView() {
        //setupLayoutForCollectionView()
        tracksCollectionView.reloadData()
    }
    
    
    
    //MARK: -setupSearchController
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        //searchController.dimsBackgroundDuringPresentation = true
        
        
        self.tabBarController?.navigationItem.hidesSearchBarWhenScrolling = true
        self.tabBarController?.navigationController?.navigationBar.isTranslucent = true
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        // Include the search controller's search bar within the table's header view.
        //        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationItem.searchController = searchController
        self.loadViewIfNeeded()
        definesPresentationContext = false
    }
    //MARK:- setupLayoutForCollectionView
    func setupLayoutForCollectionView() {
        let layout = self.tracksCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        layout.minimumInteritemSpacing = -1
    }
    
    //MARK: -setup did select track
    private func setupTrackDidSelectedToPlay() {
      
        viewModel?.playList.subscribe({[unowned self] (playListWithCurrentIndex) in
            if let plistWithCurrent = playListWithCurrentIndex {
                self.showPlayerScreen(playlist: plistWithCurrent.0, currentTrackIndex: plistWithCurrent.1)
            }
        })
    }
    
    
    //MARK: -setupDidSelectedTrackToShare
    private func setupSelectedTrackToShare(){
        viewModel?.selectedTrackToShare.subscribe({[unowned self] (selectedTrackToShare) in
            if let track = selectedTrackToShare {
                self.shareTrack(track: track)
            }
        })
    }
    
    //MARK: -shareTRACK
    func shareTrack(track:Result) {
        //        let imageOfTrack = viewModel.getImageOfUrl(url:track.artworkUrl100)
        let imageView = UIImageView()
        guard  let url = URL(string: track.artworkUrl60 ?? "") else {
            return
        }
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource,placeholder: UIImage(named: "defalut.jpg"))
        let vc = UIActivityViewController(activityItems: [imageView ,  track.trackName!,track.previewUrl!  ], applicationActivities: [])
        print("in share Track Function")
        present(vc, animated: true)
    }
    
    
    //MARK: -setup collectionView
    func setupCollectionView() {
        
        let cell = UINib(nibName: "\(ITunesTrackCollectionViewCell.cellID)", bundle: nil)
        tracksCollectionView.register(cell, forCellWithReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)")
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
    }
    
    //MARK: - ShowPlayerScreen
    func showPlayerScreen(playlist:[Result] , currentTrackIndex:Int) {
        
        if let currentTrack = currentSongInPlaying {
            if currentTrack.trackName == playlist[currentTrackIndex].trackName {
                print("Just Open Player")
                self.tabBarController?.presentPopupBar(
                    withContentViewController: popupContentController!,
                    openPopup: true,
                    animated: true,
                    completion: nil
                )
            }
            else {
                openPlayerAndPlay(playlist: playlist, currentTrackIndex: currentTrackIndex)
            }
        }
        else {
            openPlayerAndPlay(playlist: playlist, currentTrackIndex: currentTrackIndex)
        }
        
        
    }
    
    func openPlayerAndPlay(playlist:[Result] , currentTrackIndex:Int) {
        popupContentController = PlayerViewController(nibName: "\(PlayerViewController.self)", bundle: nil) as PlayerViewController
        
        popupContentController?.playList = nil
        
        popupContentController?.playList = playlist
        popupContentController?.currentTrackIndex = currentTrackIndex
        self.tabBarController?.popupBar.barStyle = .custom
        //        self.tabBarController?.popupBar.ba
        self.tabBarController?.popupBar.backgroundStyle = .dark
        self.tabBarController?.popupBar.tintColor = .label
        popupContentController?.songTitle = playlist[currentTrackIndex].trackName!
        popupContentController?.artistName = playlist[currentTrackIndex].artistName!
        popupContentController?.albumArt = UIImage(named: "default")!
      
        popupContentController?.playerDelegate = self
        
        tabBarController?.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString("Dismiss Now Playing Screen", comment: "")
        self.tabBarController?.presentPopupBar(
            withContentViewController: popupContentController!,
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




// MARK:- UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating ,UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText != "" {
                print(searchText)
                viewModel?.initFetchVM(query: searchText)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        // if you'd like to search character by character
    }
    
}



