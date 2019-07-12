//
//  DataManager.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/9/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
import RealmSwift

final class DataManager {
    
    static let shared = DataManager()
    private let dateFormatter = DateFormatter()
    
    // MARK: Field names for predicates
    
    private let dateFieldName = "date"
    
    var realm : Realm {
        return try! Realm()
    }
    
    var currentUser: User? {
        return realm.objects(User.self).first
    }
    
    func write<T: Object>(value: [T]) {
        do {
            try realm.write { realm.add(value) }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func readAll<T: Object>(object: T.Type) -> [T] {
        let result = realm.objects(T.self)
        return Array(result)
    }
    
    func readAllResult<T: Object>(object: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func deleteAll<T: Object>(_ class: T.Type) {
        let allObjects = realm.objects(T.self)
        do {
            try realm.write { realm.delete(allObjects) }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func delete<T: Object>(value: [T]) {
        do {
            try realm.write { realm.delete(value) }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func update<T: Object>(value: [T]) {
        do {
            try realm.write {
                realm.add(value, update: .modified)
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func equalityPredicate(_ fieldName: String, _ value: Any) -> NSPredicate {
        return NSPredicate(format: "\(fieldName) == %@", argumentArray: [value])
    }
    
}

// MARK: - Specific operations
extension DataManager {
    
    // strDate: 2019-07-07
    func selectAllByDate(_ strDate: String) -> [DataRecordModel] {
        
        let predicate = equalityPredicate(dateFieldName, strDate)
        let records = readAllResult(object: DataRecordModel.self).filter(predicate)
        return Array(records)
    }
    
    func updateAllByDate(strDate: String, remainingWaterQuantity: Int, totalAttepmt: Int) {
        
        let predicate = equalityPredicate(dateFieldName, strDate)
        let records = readAllResult(object: DataRecordModel.self).filter(predicate)
        do {
            try realm.write {
                records.forEach {
                    $0.remainingWaterQuantity = remainingWaterQuantity
                    $0.totalAttempt = totalAttepmt
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    func resetProgress(_ waterQuantity: Int) {
        
        let today = Date().toLocalTime()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        let predicate = equalityPredicate(dateFieldName, strDate)
        let records = readAllResult(object: DataRecordModel.self).filter(predicate)
        
        do {
            try realm.write {
                records.forEach {
                    $0.remainingWaterQuantity = waterQuantity
                    $0.totalDrink = 0
                    $0.totalAttempt = 0
                }
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
