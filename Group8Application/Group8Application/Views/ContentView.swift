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
    
   
    
    var body: some View {
        
        NavigationView{
            VStack {
                Image(systemName: "house")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                
                NavigationLink(
                    destination: StepView(healthStore: self.healthStore!),
                    label: {
                        Text("Go to step view")
                    })
            }
            .navigationTitle("Home screen")
        }
        .onAppear{
            if let HomeKit = homeKit {
                //print("unwrappat homekit")
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

