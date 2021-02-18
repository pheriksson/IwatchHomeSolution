//
//  ContentView.swift
//  test
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI
import HealthKit

//Detta är view funktionen som körs i början ContentView()


struct HeartView: View {
    
    @State private var hrData: [heartRate] = [heartRate]()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List(hrData , id: \.id) { heartRate in
                    VStack {
                        Text("\(heartRate.heartRate)")
                        Text(heartRate.date, style: .date)
                            .opacity(0.5)
                    }
                }
            }
            .navigationTitle("HearRate").padding()
        }
    }
}

struct ContentView: View {
    
    private var healthStore: HealthStore?
    private var homeKit: Fibaro?
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
        homeKit = Fibaro()
    }
    
    private func updateUIFromStatistic(statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day,value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics,stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List(steps , id: \.id) { step in
                    VStack {
                        Text("\(step.count)")
                        Text(step.date, style: .date)
                            .opacity(0.5)
                    }
                }
                NavigationLink(destination: HeartView()) {
                    Text("Click here to come to heartrate view").padding()
                }
            }
            .navigationTitle("Steps")
        }
        
            .onAppear{
                if let healthStore = healthStore {
                    print("unwrappat healthStore")
                    healthStore.requestAuthorization { success in
                        if success {
                           healthStore.calculateSteps { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    updateUIFromStatistic(statisticsCollection: statisticsCollection)
                                }
                            }
                        }
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
