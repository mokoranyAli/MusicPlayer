//
//  State.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
public enum State {
    
    case loading
    case error(error:String?)
    case empty
    case populated
    case reloading
        
}
