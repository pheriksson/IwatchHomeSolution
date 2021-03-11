//
//  StepView.swift
//  Group8Application
//
//  Created by roblof-8 on 2021-03-09.
//

import SwiftUI
import HealthKit


struct StepView: View {
    
    @State private var steps: [Step] = [Step]()
    private var healthStore: HealthStore?
    
    private func updateUIFromStatistic(statisticsCollection: HKStatisticsCollection){
        
        let startDate = Calendar.current.date(byAdding: .day,value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics,stop) in
            
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
    }
    init(healthStore : HealthStore){
        self.healthStore = healthStore
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
            }
            .navigationTitle("Steps")
        }
            .onAppear(){
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
/*
struct StepView_Previews: PreviewProvider {
    static var previews: some View {
        StepView()
    }
}*/
