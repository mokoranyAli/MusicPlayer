//
//  ITunesAPI.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/9/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import Moya

enum ITunesAPI {
   
    case searchEverything(query:String )
    
}

extension ITunesAPI {
    var sampleData: Data {
        switch self {
            
        case .searchEverything:
            return stubbedResponse("searchEverything")
     
        }
    }
    
    func stubbedResponse(_ file:String) -> Data!{
        @objc class TestClass : NSObject {}
        let b = Bundle(for: TestClass.self)
        let path = b.path(forResource: file, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
}



extension ITunesAPI :TargetType {
    
    
    var baseURL: URL {
        return URL(string:"https://itunes.apple.com/")!
    }
    
    var path: String {
        switch self {
            
     
        case .searchEverything:
            return "/search"
        
       
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    
//    var parameters:[String:Any] {
//        switch self {
//
//        case .searchEverything(let query) :
//            return ["term":query]
//
//        }
    //}
    
    
    var task: Task {
        switch self {
            
        case .searchEverything(let query) :
            return .requestParameters(parameters: ["term":query], encoding: URLEncoding.queryString)
        }
    }
    
    
    
    var headers: [String : String]? {
        return ["Content-type":"application/json"]
    }
    
    
}
