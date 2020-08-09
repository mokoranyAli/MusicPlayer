//
//  HomeViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tracksCollectionView: UICollectionView!
    var searchController: UISearchController!
    var viewModel  = TracksViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home VC")
        setupCollectionView()
        setubObservers(viewModel: viewModel)
        viewModel.initFetchVM(query: "adele")
        
        searchController = UISearchController(searchResultsController: nil)
        
        // The object responsible for updating the contents of the search results controller.
        searchController.searchResultsUpdater = self
        
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
        
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        
        let cell = UINib(nibName: "\(ITunesTrackCollectionViewCell.cellID)", bundle: nil)
        tracksCollectionView.register(cell, forCellWithReuseIdentifier: "\(ITunesTrackCollectionViewCell.cellID)")
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
    }
    
    
}


// MARK:- UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //        filterFootballers(for: searchController.searchBar.text ?? "")
        print(searchController.searchBar.text)
    }
}
