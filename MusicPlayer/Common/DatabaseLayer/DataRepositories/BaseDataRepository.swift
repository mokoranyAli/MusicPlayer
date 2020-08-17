//
//  BaseDataRepository.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
class BaseDataRepository<T> {
    
    //MARK: - Stored Properties
    var dbManager : DataManager
    
    //MARK: - Init
    required init(dbManager : DataManager) {
        self.dbManager = dbManager
    }
    
    //MARK: - Methods
    func fetch<T>(_ model: T.Type, predicate: NSPredicate? = nil, sorted: Sorted?, completion: (([T]) -> ())) where T : Storable {
        dbManager.fetchAll(model, predicate: predicate, sorted: sorted, completion: completion)
    }
    
    
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        try dbManager.deleteAll(model)
    }
    
    func delete(object: Storable) throws {
        try dbManager.delete(object: object)
    }
    
    
    func save(object: Storable) throws {
        try dbManager.save(object: object)
    }
    
  
    
}
