//
//  lamp.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-05.
//

import SwiftUI

struct lamp: View {
    

    
    @State var lampSwitch = true
    var phoneCon: PhoneConnection?
    
    init(phoneCon : PhoneConnection){
        self.phoneCon = phoneCon
    }
    
    func sendMsgToPhone(onOff : Bool, node : Int){
    
        guard let phoneCon = phoneCon else {return}
        
        var dic = [String : Any]()
        dic["FIBARO"] = true
        dic["Toggle"] = onOff
        dic["Node"] = node
        
        phoneCon.send(msg: dic)
    }
    
    var body: some View {
        VStack{
            HStack{
                if lampSwitch{
                    // Send session object to phone to change the value of the obj to true
                    Image(systemName: "lightbulb.fill").padding()
                    //sendMsgToPhone(type: "MSG", msg: "Sätt på lampan")
                }
                else {
                    Image(systemName: "lightbulb")
                }
                Toggle(isOn: $lampSwitch) {
                    
                }
            } // HStack end
        } //Vstack end
        .onAppear(){
                sendMsgToPhone(onOff: true, node: 198)
        }
    }
}
/*
struct lamp_Previews: PreviewProvider {
    static var previews: some View {
        lamp()
    }
}*/
