//
//  RealmDataManger.swift
//  MusicPlayer
//
//  Created by Mohamed Korany on 8/11/20.
//  Copyright © 2020 Mohamed Korany. All rights reserved.
//

import Foundation
import RealmSwift
enum RealmError: Error {
    case eitherRealmIsNilOrNotRealmSpecificModel
}

extension RealmError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .eitherRealmIsNilOrNotRealmSpecificModel:
            return NSLocalizedString("eitherRealmIsNilOrNotRealmSpecificModel", comment: "eitherRealmIsNilOrNotRealmSpecificModel")
        }
    }
}

class RealmDataManager {
    
    private let realm = RealmProvider.default
    
}


extension RealmDataManager: DataManager {
    
    
    func getObject<T>(_ type: T.Type, key: String) throws -> T? where T : Storable {
        guard let realm = realm, let model = type as? Object.Type else {
            
            throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel
            
        }
        
        return realm.object(ofType: model, forPrimaryKey: key) as? T
    }
    
    func checkObjectIsExistInDB<T>(_ type: T.Type, key: String) throws -> Bool {
        guard let model = type as? Object.Type else { return false }
        
        if realm?.object(ofType: model, forPrimaryKey: key) != nil { return true }
        
        return false
    }
    
    
    func save(object: Storable) throws {
        guard let realm = realm, let object = object as? Object else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        try realm.write {
            realm.add(object)
        }
    }
    
    func delete(object: Storable) throws {
        guard let realm = realm, let object = object as? Object else { print("error.......")
            throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch(let error) {
            print("error ...... is   \(print(error.localizedDescription))")
        }
    }
    
    
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        guard let realm = realm, let model = model as? Object.Type else { throw RealmError.eitherRealmIsNilOrNotRealmSpecificModel }
        try realm.write {
            let objects = realm.objects(model)
            for object in objects {
                realm.delete(object)
            }
        }
    }
    
    
    func fetchAll<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ())) where T : Storable {
        guard let realm = realm, let model = model as? Object.Type else { return }
        var objects = realm.objects(model)
        if let predicate = predicate {
            objects = objects.filter(predicate)
        }
        if let sorted = sorted {
            objects = objects.sorted(byKeyPath: sorted.key, ascending: sorted.ascending)
        }
        completion(objects.compactMap { $0 as? T })
    }
    
    
}
