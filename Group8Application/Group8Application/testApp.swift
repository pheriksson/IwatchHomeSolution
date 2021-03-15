//
//  testApp.swift
//  test
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI

@main
struct testApp: App {
    
    var fibaro: Fibaro?
    var WF : MQTTClient?
    var WC : WatchConnection?
    var healthStore : HealthStore?
    var hue : HueClient?
     
     init(){
        
        self.fibaro = Fibaro("FHC3UserName", "FHC3Password", "FHC3Address")
        self.WF = MQTTClient("MQTTBrokerAddress",1883,"User-\(String(Int.random(in: 1..<9999)))")
        self.hue = HueClient("PhilipHueBridgeAddress");
        self.healthStore = HealthStore()
        self.WC = WatchConnection(fib : self.fibaro!, hue : self.hue!)
        
        //Setup Observers.
        
        guard let wf = WF, let fibaro = fibaro, let WC = WC, let hue = hue else { return }
        wf.registerObserver(obs:fibaro)
        wf.registerObserver(obs: hue)
        fibaro.registerObserver(obs:WC)
        hue.registerObserver(obs:WC)
     }
        
     
    
    var body: some Scene {
        WindowGroup {
            ContentView(healthStore: self.healthStore!, widefind: self.WF!, homekit: self.fibaro!, wcCon: self.WC!, hue : self.hue!)
        }
    }
}
