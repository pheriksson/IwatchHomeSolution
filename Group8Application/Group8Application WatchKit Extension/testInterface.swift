
//  Created by Robert Herley on 4/28/19.
//  Copyright © 2019 Robert Herley. All rights reserved.
//
// Adapted From: https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings/speedysloth_creating_a_workout
import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {

    @IBOutlet var startStopButton: WKInterfaceButton!
    @IBOutlet var deviceLabel: WKInterfaceLabel!
    @IBOutlet var bpmLabel: WKInterfaceLabel!
    
    // Our workout session
    var session: HKWorkoutSession!
    // Live workout builder
    var builder: HKLiveWorkoutBuilder!
    // Tracking our workout state
    var workingOut = false
    // Access point for all data managed by HealthKit.
    let healthStore = HKHealthStore()
    
    @IBAction func startStopTapped() {
        if !workingOut {
            startWorkout()
            workingOut = true
            startStopButton!.setTitle("Stop")
            deviceLabel!.setText(builder!.device!.name)
        } else {
            stopWorkout()
            workingOut = false
            bpmLabel!.setText("---")
            startStopButton!.setTitle("Start")
            deviceLabel!.setText("Device Info")
        }
    }
    
    override func didAppear() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (succ, error) in
            if !succ {
                fatalError("Error requesting authorization from health store: \(String(describing: error)))")
            }
        }
    }
    
    func initWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .crossTraining
        configuration.locationType = .indoor
        
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session.associatedWorkoutBuilder()
        } catch {
            fatalError("Unable to create the workout session!")
        }
        
        // Setup session and builder.
        session.delegate = self
        builder.delegate = self
        
        /// Set the workout builder's data source.
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)
    }
    
    func startWorkout() {
        // Initialize our workout
        initWorkout()
        
        // Start the workout session and begin data collection
        session.startActivity(with: Date())
        builder.beginCollection(withStart: Date()) { (succ, error) in
            if !succ {
                fatalError("Error beginning collection from builder: \(String(describing: error)))")
            }
        }
    }
    
    func stopWorkout() {
        // Stop the workout session
        session.end()
        builder.endCollection(withEnd: Date()) { (success, error) in
            self.builder.finishWorkout { (workout, error) in
                DispatchQueue.main.async() {
                    self.session = nil
                    self.builder = nil
                }
            }
        }
    }
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let statistics = workoutBuilder.statistics(for: quantityType)
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let value = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                let stringValue = String(Int(Double(round(1 * value!) / 1)))
                bpmLabel.setText(stringValue)
                print("[workoutBuilder] Heart Rate: \(stringValue)")
            default:
                return
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Retreive the workout event.
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
}
