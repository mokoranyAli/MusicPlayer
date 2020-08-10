//
//  HomeViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    
    //MARK: - properties
    var searchController: UISearchController!
    public lazy var viewModel  = {
        return TracksViewModel()
    }()
    
    func setupLayoutForCollectionView() {
        let layout = self.tracksCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        layout.minimumInteritemSpacing = -1
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home VC")
        
        setupTrackDidSelectedToPlay()
        setupLayoutForCollectionView()
        setupCollectionView()
        setubObservers(viewModel: viewModel)
        setupSearchController()
        
        
        
    }
    
    //MARK: -setup reloading Collection View
    override func reloadTableView() {
        //setupLayoutForCollectionView()
        tracksCollectionView.reloadData()
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        // Determines whether the underlying content is dimmed during a search.
        // if we are presenting the display results in the same view, this should be false
        //searchController.dimsBackgroundDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isTranslucent = true
        // Make sure the that the search bar is visible within the navigation bar.
        searchController.searchBar.sizeToFit()
        // Include the search controller's search bar within the table's header view.
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: -setup did select track
    
    func setupTrackDidSelectedToPlay() {
        viewModel.selectedTrack.subscribe({[unowned self] (selectedTrack) in
            if let track = selectedTrack {
                self.showPlayerScreen(track: track)
            }
        })
    }
    
    
    
    //MARK: -setup collectionView
    func setupCollectionView() {
        
        let cell = UINib(nibName: "\(ITunesTrackCollectionViewCell.cellID)", bundle: nil)
        tracksCollectionView.register(cell, forCellWithReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)")
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        
        //        tracksCollectionView.DelegateFlowLayout = self
    }
    
    
    func showPlayerScreen(track:Result) {
        let playerViewController = storyboard?.instantiateViewController(identifier: "\(PlayerViewController.self)") as! PlayerViewController
        playerViewController.currentTrack = track
        navigationController?.pushViewController(playerViewController, animated: true)
    }
    
}


// MARK:- UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating ,UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            if searchText != "" {
                print(searchText)
                viewModel.initFetchVM(query: searchText)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //        filterFootballers(for: searchController.searchBar.text ?? "")
        
        
        
        
    }
    
    
    
}
