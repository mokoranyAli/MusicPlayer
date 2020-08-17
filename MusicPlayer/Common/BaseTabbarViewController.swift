//
//  TestViewController.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import Localize_Swift
import SideMenuSwift

class BaseTabbarViewController: UITabBarController {

    open var setupMenuButton: UIBarButtonItem {
           return UIBarButtonItem(title: "Menu".localized(), style: .plain, target: self, action: #selector(self.menuButtonPressed(_:)))
       }

       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           NotificationCenter.default
               .addObserver(self, selector: #selector(setLocalizedUI), name: Notification.Name(LCLLanguageChangeNotification),
                            object: nil)
       }


       override func viewDidLoad() {
           setLocalizedUI()
           super.viewDidLoad()

       }


       @objc func setLocalizedUI() {
           SideMenuController.preferences.basic.direction = Localize.currentLanguage() == "ar" ? .right : .left

           navigationItem.leftBarButtonItem = setupMenuButton

       }


       @objc func menuButtonPressed(_ tapped: UIBarButtonItem){
           self.sideMenuController?.revealMenu()
       }

}
