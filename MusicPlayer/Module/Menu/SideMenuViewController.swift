//
//  SideMenuViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import Localize_Swift
import SideMenuSwift

class SideMenuViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    public weak var navigationBase : BaseNavigationController?
    
      private lazy var dataSource = SideMenuDataSource()
      
      override func viewDidLoad() {
          super.viewDidLoad()
        
          configureTableView()
          reloadTableViewData()
        print("Menu VC")
      }
    
    func changeLanguage() {
            sideMenuController?.hideMenu()
            
            let newLanguage = Localize.currentLanguage() == "ar" ? "en" : "ar"
            Localize.setCurrentLanguage(newLanguage)
            
            (UIApplication.shared.delegate as? AppDelegate)?.configureRootViewController()
        }
        
        
    }

    // MARK: - Configure View

    private extension SideMenuViewController {
        
        func configureTableView() {
            tableView.delegate = self
            tableView.dataSource = dataSource
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
            tableView.tableFooterView = UIView()
        }
        
        func reloadTableViewData() {
            dataSource.reloadSections()
        }
        
    }

    // MARK: - Configure UITableViewDelegate
    //
    extension SideMenuViewController: UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)

            switch dataSource.rows[indexPath.row].type {
            case .changeLanguage:
                changeLanguage()
            case .favorite:
                let favoriteVC = FavoriteViewController()
                navigate(to: favoriteVC)
            case .home :
                let homeVC = storyboard?.instantiateViewController(identifier: "\(TestViewController.self)") as! TestViewController
                 
                navigate(to: homeVC)
                //self.navigationController?.popViewController(animated: true)
            default:
                break
            }
        }
    }
    // MARK: - Navigation Helpers
    //
    extension SideMenuViewController {
      func navigate(to viewController: UIViewController) {
        sideMenuController?.hideMenu()
        
        navigationBase?.pushViewController(viewController, animated: true)
      }
      
    }
