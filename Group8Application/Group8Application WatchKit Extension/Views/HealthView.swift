//
//  HealthView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-02-22.
//

import SwiftUI

struct HealthView: View {
    var store: HealthStoreWatch?

    
    init(store: HealthStoreWatch){
        self.store = store
    }
    
    var body: some View {
        VStack{
            Text("HR").padding()
           
        }
    }
}
/*
struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView()
    }
}*/
