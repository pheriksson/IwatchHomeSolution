//
//  PhilipHueView.swift
//  Group8Application WatchKit Extension
//
//  Created by Sven Andersson on 3/10/21.
//

import SwiftUI

struct PhilipHueView: View {
    
    @ObservedObject var lights : HueContainer
    var WMC : PhoneConnection
    
    init(phoneCon : PhoneConnection){
        self.WMC = phoneCon
        self.lights = WMC.getHueContainer()
    }
    
    var body: some View {
        if(lights.getHueLightStatus()){
            Text("Lights recieved.")
            let recievedLights = lights.getHueLights()
            ForEach(recievedLights.keys.sorted(), id: \.self) { key in
                    HStack {
                        //Text(key)
                        //Text("\(recievedLights[key]!)")
                        PhilipHueToggleView(WMC: self.WMC,id : key, onOff: recievedLights[key]!, firstClick : [true])
                    }
                }
            
        }else{
            Text("Retrieving lights from PhilipHue")
            Image(systemName: "hourglass")
        }
        
    }
}

/*

struct PhilipHueView_Previews: PreviewProvider {
    static var previews: some View {
        PhilipHueView()
    }
}
*/
