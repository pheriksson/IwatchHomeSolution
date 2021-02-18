//
//  HeartRateView.swift
//  test
//
//  Created by roblof-8 on 2021-02-12.
//

import SwiftUI
import HealthKit

struct HeartRateView: View {
    
    //Detta är en annan sida på applikation (HR sidan har bara gjort Steps)
    
    @State private var hrData: [heartRate] = [heartRate]()
    
    var body: some View {
        Text("jag är här").padding()
        /*NavigationView {
            VStack(spacing: 30) {
                List(hrData , id: \.id) { heartRate in
                    VStack {
                        Text("\(heartRate.heartRate)")
                        Text(heartRate.date, style: .date)
                            .opacity(0.5)
                    }
                }
            }
            
            .navigationTitle("HearRate")
        }*/
    }
}

struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}
