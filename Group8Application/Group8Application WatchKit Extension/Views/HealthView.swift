//
//  HealthView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import SwiftUI

struct HealthView: View {
    var store: HealthStoreWatch?
    @State private var bol: Bool = false
    @State private var heartRate: Int = 0
    

    
    init(store: HealthStoreWatch?){
        self.store = store
    }
    
    var body: some View {
        VStack{
            if bol == true {
                Text("den e true").padding()
            } else {
                Text("Den e false").padding()
            }
            
            Button(action: {
                self.bol.toggle()
            }, label: {
                Text("Change state")
            })
            Text(String(heartRate)).padding()
        }
        .onAppear(){
            updateHR()
        }
    }
    
    func updateHR() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            print("update health variable")
            self.heartRate = self.store!.getHeartRate()
            updateHR()
        }
    }
}


/*
struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}*/
