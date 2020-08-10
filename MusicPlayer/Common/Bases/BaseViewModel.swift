//
//  BaseViewModel.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import Foundation
class BaseViewModel  {
    var apiProtocol: ITunesRepoProtocol?
    var observState: Observable<State?>?
   
    init(_ apiManager : ITunesRepoProtocol = ITunesRepo()){
           self.apiProtocol = apiManager
           self.observState = Observable<State?>(.empty)
       }
}
