//
//  AppDelegate.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import UIKit
import SideMenuSwift
import Localize_Swift
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = false
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
//            print("Playback OK")
//            try AVAudioSession.sharedInstance().setActive(true)
//            print("Session is Active")
//        } catch {
//            print(error)
//        }
        configureRootViewController()
        
        return true
    }

    
    func configureRootViewController() {
            //guard let windowScene = scene as? UIWindowScene else { return }
            let isRTL = Localize.currentLanguage() == "ar"
            SideMenuController.preferences.basic.direction = isRTL ? .right : .left
           
            let semanticAttribute: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
            UIView.appearance().semanticContentAttribute = semanticAttribute
            UINavigationBar.appearance().semanticContentAttribute = semanticAttribute
            
            let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
              window = UIWindow(frame: UIScreen.main.bounds)
    //          window = UIWindow(windowScene: windowScene)
                        
        
        if #available(iOS 13.0, *) {
            let contentViewController = mainStoryboard.instantiateViewController(identifier: "ContentNavigation")
            
                     let menuViewController = mainStoryboard.instantiateViewController(identifier: "MenuNavigation") as! SideMenuViewController
                     /// You should set navigation base with the actual navigation controller
                     menuViewController.navigationBase = (contentViewController as! BaseNavigationController)
                   
                       window?.rootViewController = SideMenuController(contentViewController: contentViewController, menuViewController: menuViewController)
                     print("Root View Controller \(window?.rootViewController)")
                       window?.makeKeyAndVisible()
        } else {
            // Fallback on earlier versions
        }
         
        }

}

