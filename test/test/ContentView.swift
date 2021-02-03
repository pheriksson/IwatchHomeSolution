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
    
    init() {
        healthStore = HealthStore()
    }
    
    var body: some View {
        Text("Our first Application")
            .padding()
        
            .onAppear{
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success in
                        
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
