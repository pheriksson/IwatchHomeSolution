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
        print("Nu körs auth")
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        print("type skapad")
        guard let healthStore = self.healthStore else { return completion(false)}
        print("healthStore objektet är skapat")
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            completion(success)
            print("auth gick igenom")
        }
        print("funktion är slut")
    }
    
   
    //Beräknar steps under en viss period och sparar data i en collection
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
    
    //så nu kör xD
   
    //Hämtar hr data
    func latestHeartRate(){
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) {
            (sample, result, error) in
            guard error == nil else{
                return
            }
            /*
            let data = result![0] as! HKQuantitySample
            let unit = HKUnit(from: "count/min")
            let latestHr = data.quantity.doubleValue(for: unit)
            //print("Latest Hr)*/
        }
        healthStore?.execute(query)
        print("query executed")
    }
    
   
}
