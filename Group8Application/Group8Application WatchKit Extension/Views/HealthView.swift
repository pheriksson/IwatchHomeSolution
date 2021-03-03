//
//  HealthView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import SwiftUI

struct HealthView: View {
    var store: HealthStoreWatch?
    //var controller: InterfaceController?
    
    init(store: HealthStoreWatch){
        self.store = store
    }
    
    var body: some View {
        VStack{
            Text("HR display").padding()
           // Button(action: , label: {
             //   Text("Workout?")
            //})
        }
    }
}
/*
struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}*/
