//
//  lamp.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-05.
//

import SwiftUI

struct lamp: View {
    

    
    @State var lampSwitch = false
    var phoneCon: PhoneConnection?
    
    init(phoneCon : PhoneConnection){
        self.phoneCon = phoneCon
    }
    
    func sendMsgToPhone(onOff : Int, node : Int){
        print("kör vi denna func?")
        guard let phoneCon = phoneCon else {return}
        
        var dic = [String : Any]()
        dic["FIBARO"] = true
        dic["CODE"] = onOff
        dic["NODE"] = node
        
        phoneCon.send(msg: dic)
    }
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(0...2){ index in
                    HStack{
                        if lampSwitch{
                            // Send session object to phone to change the value of the obj to true
                            Image(systemName: "lightbulb.fill").padding()
                            ToggleView(phoneCon: self.phoneCon!)
                            
                            
                            //sendMsgToPhone(onOff: true, node: 198)
                        }
                        else {
                            Image(systemName: "lightbulb")
                            //Text("\(self.turnOff())")
                        }
                        Toggle(isOn: $lampSwitch) {
                            //Text("\(self.test())")
                        }
                    } // HStack end
                }
            }
        } //Vstack end
        //.onAppear(){
        //        sendMsgToPhone(onOff: true, node: 198)
        //}
    }
    
/*    func turnOn() -> String
    {
        sendMsgToPhone(onOff: 1, node: 198)
        return ""
    }
    func turnOff() -> String
    {
        sendMsgToPhone(onOff: 0, node: 198)
        return ""
    }*/
}
/*
struct lamp_Previews: PreviewProvider {
    static var previews: some View {
        lamp()
    }
}*/
