//
//  HealthStoreWatch.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import Foundation
import HealthKit
import WatchKit


/*
class HealthStoreWatch: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    @IBOutlet var bpmLabel: WKInterfaceLabel!
    let healthStore: HKHealthStore?
    let session: HKWorkoutSession?
    let builder: HKLiveWorkoutBuilder?


    override init() {
        healthStore = HKHealthStore()
        if (HKHealthStore.isHealthDataAvailable()) {
            
            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .running
            configuration.locationType = .outdoor
            
            guard let healthStore = healthStore else { return }
            
            
            do {
                session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
                builder = session?.associatedWorkoutBuilder()
            } catch {
                // Handle failure here.
                return
            }
            guard let session = session else { return }
            guard let builder = builder else { return }
            
            builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            
            
            session.delegate = self
            builder.delegate = self
        }
    }
    
    func requestAuthorization(completion:@escaping (Bool) ->Void) {
        
        // Readable/Writable data
       // let allTypes = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!])
    
        let typesToShare = Set([HKQuantityType.workoutType()])
        
        //Quantities to read from HealthStore
        let typesToRead = Set([
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ])
        
        //unwrapping healthStore i.e checking if healthstore has been initiated and not nil
        guard let healthStore = self.healthStore else { return completion(false)}
        
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            completion(success)
        }
    }
    
    func startHeartRate() {
        
        guard let session = session, let builder = builder else {
            print("session or builder null pointer")
            return
        }
        
        
        session.startActivity(with: Date())
        
        builder.beginCollection(withStart: Date()) { (success, error) in
            
            guard success else {
                print("error occured in begin collections")
                // Handle errors.
            }
            print("Session started")
            // Indicate that the session has started.
        }
    }
}*/
