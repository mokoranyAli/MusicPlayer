//
//  ITunesRepo.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class ITunesRepo : ITunesRepoProtocol {
    let network:Networkable = NewtorkManger()
       
    func searchEverything(query: String,  ComplitionHandler: @escaping tracksComplition) {
        network.fetchData(target: .searchEverything(query: query), complitionHandler: ComplitionHandler)
    }
    


}
