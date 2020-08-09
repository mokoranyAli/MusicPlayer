//
//  NetworkManger.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import Moya
protocol Networkable {
     func fetchData <T:Codable> (target:ITunesAPI , complitionHandler:@escaping (T? , APIError?) -> ())
   
}


class NewtorkManger:Networkable {
 
    fileprivate let provider = MoyaProvider<ITunesAPI>()
    func fetchData <T:Codable> (target:ITunesAPI , complitionHandler: @escaping (_ result : T? , _ error : APIError?) -> ()) {
        
        provider.request(target) { (result) in
                    switch  result {
                case .success(let response) :
                    do {
                        let resultApi = try JSONDecoder().decode(T.self, from: response.data)
                        complitionHandler(resultApi,nil)
                        
                    }catch(let ex) {
                        print(#function, "exception with: \(ex)")
                        complitionHandler(nil,.notFound)
                    }
                    
                case .failure(let error) :
                    print(#function, "error with: \(error)")
                    complitionHandler(nil,.noInternet)
                }
        }
    }
}

enum APIError : String, Error {
    case noInternet = "Please check internet connection"
    case notFound = "No data found or page removed"
}
