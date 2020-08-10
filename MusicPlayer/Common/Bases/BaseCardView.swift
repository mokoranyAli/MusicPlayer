//
//  BaseCardView.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/10/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class BaseCardView:UIView {
    
    @IBInspectable var cornerRedius:Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            //self.layer.masksToBounds = true
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    
    @IBInspectable var shadowColor:UIColor? {
           get {
            return UIColor(cgColor: self.layer.shadowColor!)
           }
           set {
              
            self.layer.shadowColor = newValue?.cgColor
            //print("color is \(newValue?.cgColor)")
            
           }
       }
    @IBInspectable var borderColor:UIColor? {
        get {
         return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
           
         self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth:Double {
          get {
              return Double(self.layer.borderWidth)
          }
          set {
              
              self.layer.borderWidth = CGFloat(newValue)
          }
      }
    
    
    @IBInspectable var shadowRedius:CGFloat {
          get {
              return CGFloat(self.layer.shadowRadius)
          }
          set {
            
              self.layer.shadowRadius = CGFloat(newValue)
          }
      }
    
    @IBInspectable var shadowOpacity:Float {
             get {
                 return Float(self.layer.shadowOpacity)
             }
             set {
                 
                 self.layer.shadowOpacity = Float(newValue)
             }
         }
    
    
    
       func setupCardViewAppearanceAutomatically() {
           // corner radius
           self.layer.cornerRadius = 10

           // border
           self.layer.borderWidth = 0.1
           self.layer.borderColor = UIColor.black.cgColor

           // shadow
           self.layer.shadowColor = UIColor.black.cgColor
         //  cardView.layer.shadowOffset = CGSize(width: 3, height: 3)
          self.layer.shadowOpacity = 1
           self.layer.shadowRadius = 5.0
       }
}
