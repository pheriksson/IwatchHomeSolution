//
//  lamp.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-05.
//

import SwiftUI

struct lamp: View {
    

    
    @State var lampSwitch = true
    //var listOfBinSwitch []
    
    var body: some View {
        VStack{
            HStack{
                if lampSwitch{
                    // Send session object to phone to change the value of the obj to true
                    Image(systemName: "lightbulb.fill")
                }
                else {
                    Image(systemName: "lightbulb")
                }
                Toggle(isOn: $lampSwitch) {
                    
                }
            }
            
        }
        
        
    }
}

struct lamp_Previews: PreviewProvider {
    static var previews: some View {
        lamp()
    }
}
