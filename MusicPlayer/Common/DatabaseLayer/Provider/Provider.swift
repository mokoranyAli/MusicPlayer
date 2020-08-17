//
//  Provider.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import Foundation
import RealmSwift

//MARK: - RealmProvider
struct RealmProvider {
    
    //MARK: - Stored Properties
    let configuration: Realm.Configuration
    
    //MARK: - Init
    internal init(config: Realm.Configuration) {
        configuration = config
    }
    
    //MARK: - Init
    private var realm: Realm? {
        do {
            return try Realm(configuration: configuration)
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //MARK: - Configuration
    private static let defaultConfig = Realm.Configuration(schemaVersion: 1)
    private static let mainConfig = Realm.Configuration(
        fileURL:  URL.inDocumentsFolder(fileName: "main.realm"),
        schemaVersion: 1)
    
    
    //MARK: - Realm Instances
    public static var `default`: Realm? = {
        return RealmProvider(config: RealmProvider.defaultConfig).realm
    }()
    public static var main: Realm? = {
        return RealmProvider(config: RealmProvider.mainConfig).realm
    }()
}

extension URL {
    
    // returns an absolute URL to the desired file in documents folder
    fileprivate static func inDocumentsFolder(fileName: String) -> URL {
        return URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0], isDirectory: true)
            .appendingPathComponent(fileName)
    }
}
