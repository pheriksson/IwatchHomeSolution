//
//  HeartRateView.swift
//  test
//
//  Created by roblof-8 on 2021-02-12.
//

import SwiftUI
import HealthKit

struct HeartRateView: View {
    
    
    @State private var hrData: [heartRate] = [heartRate]()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                List(hrData , id: \.id) { heartRate in
                    VStack {
                        Text("\(heartRate.heartRate)")
                        Text(heartRate.date, style: .date)
                            .opacity(0.5)
                    }
                }
            }
            .navigationTitle("HearRate").padding()
        }
    }
}







struct HeartRateView_Previews: PreviewProvider {
    static var previews: some View {
        HeartRateView()
    }
}
