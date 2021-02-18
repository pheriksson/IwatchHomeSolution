//
//  ContentView.swift
//  test WatchKit Extension
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI
import HealthKit



private func updateUIFromStatistic(statisticsCollection: HKStatisticsCollection){
    
    let startDate = Calendar.current.date(byAdding: .day,value: -7, to: Date())!
    let endDate = Date()
    
    statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics,stop) in
        
        let count = statistics.sumQuantity()?.doubleValue(for: .count())
        
        let step = Step(count: Int(count ?? 0), date: statistics.startDate)
        steps.append(step)
    }
}

struct ContentView: View {
    
    private var healthStore: HealthStore?
    private var homeKit: Fibaro?
    @State private var steps: [Step] = [Step]()
    
    init() {
        healthStore = HealthStore()
        //homeKit = Fibaro()
    }
    
    var body: some View {
        
        VStack {
            Text("Vår health app").padding()
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Text("button")
            }
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

