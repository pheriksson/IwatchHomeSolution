//
//  toggleView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-07.
//

import Foundation
import SwiftUI



struct ToggleView : View {
    @State var isChecked: Bool = true
    
    var phoneCon: PhoneConnection?
    
    init(phoneCon : PhoneConnection){
        self.phoneCon = phoneCon
    }
    
    var body: some View{
        Toggle(isOn: self.$isChecked){
            Text("Label")
        }
        if(isChecked)
        {
            Text("\(self.turnOn())")
        }
        else{
            Text("\(self.turnOff())")
        }
    }

    
    func turnOn() -> String
    {
        sendMsgToPhone(onOff: 1, node: 198)
        return ""
    }
    func turnOff() -> String
    {
        sendMsgToPhone(onOff: 0, node: 198)
        return ""
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
}

