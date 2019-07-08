//
//  DBManager.swift
//  HydroFuel
//
//  Created by Serg Liamthev on 7/6/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

typealias DBOperationResult = (success: String, failure: String, status: Int)
typealias DBRecordOperationResult = (arrData: [DataRecordModel], success: String, failure: String, status: Int)

final class DBManager {
    
    static let shared = DBManager()
    private let dateFormatter = DateFormatter()
    
    @discardableResult
    func createDB() -> DBOperationResult{
        
        let strURL = "CREATE TABLE IF NOT EXISTS HYDROFUELPERSINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, WEIGHT INTEGER, GENDER TEXT, ACTIVITYLAVEL TEXT, WATERQTY INTEGER, REMAININGWATERQTY INTEGER, TOTALDRINK INTEGER, TOTALATTEMPT INTEGER, WATERQTYPERATTEMPT INTEGER)"
        return AFSQLWrapper.createTable(strURL)
    }
    
    func selectAll() -> DBRecordOperationResult {
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO"
        return AFSQLWrapper.selectTable(strURL)
    }
    
    func selectAllByDate(_ strDate: String) -> DBRecordOperationResult {
        
        let strURL = "SELECT * FROM HYDROFUELPERSINFO where DATE='\(strDate)'"
        return AFSQLWrapper.selectIdDataTable(strURL)
    }
    
    @discardableResult
    func insertData(date: String, weight: Int, gender: String, activityLevel: String, waterQty: Int,
                    remainingWaterQty: Int, totalDrink: Int, totalAttempt: Int, waterQtyPerAttempt: Int) -> DBOperationResult {
        
        let strURL = "INSERT INTO HYDROFUELPERSINFO (DATE, WEIGHT, GENDER, ACTIVITYLAVEL, WATERQTY, REMAININGWATERQTY, TOTALDRINK, TOTALATTEMPT, WATERQTYPERATTEMPT) VALUES ('\(date)', '\(weight)', '\(gender)', '\(activityLevel)', '\(waterQty)', '\(remainingWaterQty)', '\(totalDrink)', '\(totalAttempt)', '\(waterQtyPerAttempt)')"
        
        let operationResult = AFSQLWrapper.insertTable(strURL)
        return operationResult
    }
    
    @discardableResult
    func firstInsertData(date: String, weight: Int, gender: String, activityLevel: String, waterQty: Int, remainingWaterQty: Int, totalDrink: Int, totalAttempt: Int, waterQtyPerAttempt: Int) -> DBOperationResult {
        
        let strURL = "INSERT INTO HYDROFUELPERSINFO (DATE, WEIGHT, GENDER, ACTIVITYLAVEL, WATERQTY, REMAININGWATERQTY, TOTALDRINK, TOTALATTEMPT, WATERQTYPERATTEMPT) VALUES ('\(date)', '\(weight)', '\(gender)', '\(activityLevel)', '\(waterQty)', '\(remainingWaterQty)', '\(totalDrink)', '\(totalAttempt)', '\(waterQtyPerAttempt)')"
        
        let operationResult = AFSQLWrapper.insertTable(strURL)
        return operationResult
    }
    
    @discardableResult
    func updateData(weight: Int, gender: String, activityLevel: String, waterQty: Int, remainingWaterQty: Int, totalDrink: Int, waterQtyPerAttempt: Int) -> DBOperationResult {
        
        let today = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        
        let strURL = "update HYDROFUELPERSINFO set WEIGHT='\(weight)', GENDER='\(gender)', ACTIVITYLAVEL='\(activityLevel)', WATERQTY='\(waterQty)', REMAININGWATERQTY='\(remainingWaterQty)', TOTALDRINK='\(totalDrink)', WATERQTYPERATTEMPT='\(waterQtyPerAttempt)' where DATE='\(strDate)'"
        
        let operationResult = AFSQLWrapper.updateTable(strURL)
        return operationResult
    }
    
    func resetCurrentProgress(waterQuantity: Int) -> (DBOperationResult, resetDate: String) {
        
        let today = Date().toLocalTime()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let strDate = dateFormatter.string(from: today)
        let strURL = "update HYDROFUELPERSINFO set REMAININGWATERQTY='\(waterQuantity)', TOTALDRINK='\(0)',TOTALATTEMPT='\(0)' where DATE='\(strDate)'"
        
        let result = AFSQLWrapper.updateTable(strURL)
        return (result, strDate)
    }
    
}
