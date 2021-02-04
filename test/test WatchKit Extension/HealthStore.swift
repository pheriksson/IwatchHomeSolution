//
//  HealthStore.swift
//  test
//
//  Created by Robin Olofsson on 2021-01-28.
//

import Foundation
import HealthKit

class HealthStore{
    var healthStore: HKHealthStore?
    
    init() {
        if (HKHealthStore.isHealthDataAvailable()) {
            healthStore = HKHealthStore()
        }
    }
    
   
    func requestAuthorization(completion:@escaping (Bool) ->Void) {
        let read = Set([HKQuantityType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKQuantityType.quantityType(forIdentifier: .heartRate)!])
        
        guard let healthStore = self.healthStore else {
            return completion(false)
        }
        
        
        healthStore.requestAuthorization(toShare: share, read: read) { (success, error) in
            if(success){
                print("Persmission granted")
                self.latestHeartRate()
                print("We runned the hr function")
            }
        }
    }
    
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
    
    //func calculateSteps(completion: @escaping (HKStatisticsCollection?) -> Void)
}
