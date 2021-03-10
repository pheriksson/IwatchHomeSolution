//
//  HealthStore.swift
//  test
//
//  Created by Robin Olofsson on 2021-01-28.
//

import Foundation
import HealthKit

//HealthStore classes som hanterar ett object av HKHealtStore, med lite funktioner för att hämta data.
//Har även skrivit steps är inne eftersom HKHealthStore hanterar all typ av data.

extension Date{
    static func mondatAt12AM() -> Date {
        return Calendar(identifier: .iso8601).date(from: Calendar(identifier: .iso8601).dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
    }
}

class HealthStore{
    var healthStore: HKHealthStore?
    var query: HKStatisticsCollectionQuery?
    
    init() {
        
        if (HKHealthStore.isHealthDataAvailable()) {
            healthStore = HKHealthStore()
        }
    }
    
    //Request auth innan man får använda olika var i HKHealthStore t.ex steps/HR
    
    func requestAuthorization(completion:@escaping (Bool) ->Void) {
        
        // Readable data
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!,HKObjectType.workoutType()])
    
        
        
        //Wrapping healthStore i.e checking if healthstore has been initiated and not nil
        guard let healthStore = self.healthStore else { return completion(false)}
        
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            completion(success)
        }
    }
    
   
    //Calculates the steps taken under a period of time
    func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        
        let anchorDate = Date.mondatAt12AM()
        
        let daily = DateComponents(day:1)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        
        query = HKStatisticsCollectionQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: daily)
        
        query!.initialResultsHandler = { query, HKStatisticsCollection, error in completion(HKStatisticsCollection)}
        
        if let healthStore = healthStore, let query = self.query {
            healthStore.execute(query)
        }
        
    }
}
