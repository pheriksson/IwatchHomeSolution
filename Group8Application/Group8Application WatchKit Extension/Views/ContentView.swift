//
//  ContentView.swift
//  test WatchKit Extension
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI
import HealthKit



struct ContentView: View {
    
    var store: HealthStoreWatch?
    
    init() {
        store = HealthStoreWatch()
    }
    
    var body: some View {
        
        VStack {
            Text("Group-8 App").padding()
            
            NavigationLink(
                destination: HealthView(),
                label: {
                    HStack {
                        Text("Health App")
                        Image(systemName: "heart")
                    }
            })
                    
            NavigationLink(
                destination: FibaroView(),
                label: {
                    Text("Fibaro")
                    Image(systemName: "house")
            })
            
            NavigationLink(
                destination: ZWaveView(),
                label: {
                    Text("Z-wave")
                    Image(systemName: "zzz")
            })
        }
        
        .onAppear{
            if let store = store {
                print("unwrappat healthStore")
                store.requestAuthorization { success in
                    if success {
                       print("We made it")
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

