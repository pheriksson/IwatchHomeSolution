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
    var wf : MQTTClient?
    var WC : WatchConnection?
    var healthStore : HealthStore?
    var hue : HueClient?
     
     //Send pointers of state variables thourh content view.
     init(){
        self.fibaro = Fibaro("unicorn@ltu.se", "jSCN47bC", "130.240.114.44")
        self.wf = MQTTClient("130.240.74.55",1883,"GRP8-\(String(Int.random(in: 1..<9999)))")
        self.healthStore = HealthStore()
        self.hue = HueClient("130.240.114.9");
        self.WC = WatchConnection(fib : self.fibaro!, hue : self.hue!)
        
        //Setup OO
        
        guard let wf = wf, let fibaro = fibaro, let WC = WC, let hue = hue else { return }
       
        wf.registerObserver(obs:fibaro)
        wf.registerObserver(obs: hue)
        fibaro.registerObserver(obs:WC)
        hue.registerObserver(obs:WC)
     }
        
     
    
    var body: some Scene {
        WindowGroup {
            ContentView(healthStore: self.healthStore!, widefind: self.wf!, homekit: self.fibaro!, wcCon: self.WC!, hue : self.hue!)
            //And then pass the initialized state variables to the view.
            //ContentView(fibaro,healthStore)
        }
    }
}
