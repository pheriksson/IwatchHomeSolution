//
//  HealthStoreWatch.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import Foundation
import HealthKit

class HealthStoreWatch {
    var HStore: HKHealthStore?
    
    init() {
        if (HKHealthStore.isHealthDataAvailable()) {
            HStore = HKHealthStore()
        }
    }
    
    func requestAuthorization(completion:@escaping (Bool) ->Void) {
        
        // Readable/Writable data
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!])
    
        
        
        //unwrapping healthStore i.e checking if healthstore has been initiated and not nil
        guard let HStore = self.HStore else { return completion(false)}
        
        
        HStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            completion(success)
        }
    }
}
