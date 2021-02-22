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
}
