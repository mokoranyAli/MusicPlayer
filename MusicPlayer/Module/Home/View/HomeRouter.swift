//
//  HomeRouter.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/17/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import UIKit
class HomeRouter {
    
    static func createModule()->BaseNavigationController {
        
        
        let contentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ContentNavigation") as! BaseNavigationController
        
        
        //        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(HomeViewController.self)") as! HomeViewController
        
        let tabbar = contentViewController.children[0] as? BaseTabbarViewController
        let homeVC = tabbar?.children[0] as? HomeViewController
        let homeViewModel = TracksViewModel(favoriteViewModel: FavoriteViewModel())
        homeVC?.viewModel = homeViewModel
        
        return contentViewController
        
        
    }
    
    
    static func createModuleWithoutNavigation()-> BaseTabbarViewController {
        
        
        let tabbar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(BaseTabbarViewController.self)") as! BaseTabbarViewController
        
        let homeVC = tabbar.viewControllers?[0] as! HomeViewController
        
        let homeViewModel = TracksViewModel(favoriteViewModel: FavoriteViewModel())
        homeVC.viewModel = homeViewModel
        return tabbar
    }
}
