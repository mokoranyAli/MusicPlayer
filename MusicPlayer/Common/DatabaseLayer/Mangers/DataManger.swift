//
//  DataManger.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import RealmSwift
//MARK: - DataManager Protocol

protocol DataManager {
    
   
    func save(object: Storable) throws

    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func fetchAll<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
    func getObject<T: Storable>(_ type: T.Type, key: String) throws -> T?
    func checkObjectIsExistInDB<T>(_ type: T.Type, key: String) throws -> Bool
    
}


//MARK: - Storable Protocol
/*CRUD tasks perform operation on persistence specific object since we are creating generic protocol we need to program to an interface instead of concrete implementation*/
public protocol Storable {
    
}



/*To sort the fetch result common interface is created for this purpose since different persistence framework provides different interface for sorting*/
public struct Sorted {
    var key: String
    var ascending: Bool = true
}


extension Object: Storable {
}
