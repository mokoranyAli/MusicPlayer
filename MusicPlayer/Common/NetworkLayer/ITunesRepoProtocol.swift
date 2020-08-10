//
//  ITunesRepoProtocol.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
typealias tracksComplition = (_ responseModel : ResponseResult? , _ errorMessage:  APIError?) -> ()

protocol ITunesRepoProtocol {
 func searchEverything(query:String , ComplitionHandler:@escaping tracksComplition)

}
