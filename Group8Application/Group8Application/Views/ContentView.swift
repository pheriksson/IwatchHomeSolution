//
//  ContentView.swift
//  test
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI
import HealthKit


struct ContentView: View {
    
    private var healthStore: HealthStore?
    private var homeKit: Fibaro?
    private var wideFind: MQTTClient?
    private var watchConnection: WatchConnection
    private var hue : HueClient
    @State private var steps: [Step] = [Step]()
    
    init(healthStore: HealthStore, widefind: MQTTClient, homekit : Fibaro, wcCon : WatchConnection, hue : HueClient) {
        self.healthStore = healthStore
        self.wideFind = widefind
        self.homeKit = homekit
        self.watchConnection = wcCon
        self.hue = hue
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
                NavigationLink(destination: HeartRateView()) {
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
                if let HomeKit = homeKit {
                    print("unwrappat homekit")
                    //HomeKit.getBinarySwitches()
                    //HomeKit.turnOnSwitch(id: 198)
                }
            }
        
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(healthStore: <#HealthStore#>, widefind: <#MQTTClient#>, homekit: <#Fibaro#>, wcCon: <#WatchConnection#>)
    }
}*/

