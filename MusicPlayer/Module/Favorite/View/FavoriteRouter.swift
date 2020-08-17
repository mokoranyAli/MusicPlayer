//
//  FavoriteRouter.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/17/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class FavoriteRouter {
    
    static func createModule()-> BaseTabbarViewController {
        
        let tabbar = BaseTabbarViewController()
        let favoriteVC = FavoriteViewController(nibName: "\(FavoriteViewController.self)", bundle: nil) as FavoriteViewController
        
        favoriteVC.favoritViewModel = FavoriteViewModel()
        tabbar.viewControllers = [favoriteVC]
        
        return tabbar
        
        
    }
}
