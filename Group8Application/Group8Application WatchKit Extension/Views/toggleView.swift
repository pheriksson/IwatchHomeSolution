//
//  toggleView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-07.
//

import Foundation
import SwiftUI

struct ToggleView : View {
    
    @State var isChecked: Bool = false
   
    var phoneCon: PhoneConnection?
    let name: String?
    let id : Int?
    
    init(phoneCon : PhoneConnection, name : String, id : Int, status : Bool){
        self.phoneCon = phoneCon
        self.name = name
        self.id = id
        self.isChecked = status
    }
    
    var body: some View{
        
        Image(systemName: "lightbulb.fill").padding()
        Toggle(isOn: self.$isChecked){
            Text(name!)
        }
        if(isChecked)
        {
            Text("\(self.turnOn(node: self.id!))")
        }
        else{
            Text("\(self.turnOff(node: self.id!))")
        }
    }

    
    func turnOn(node : Int) -> String
    {
        print(id)
        sendMsgToPhone(onOff: 1, node: node)
        return ""
    }
    func turnOff(node : Int) -> String
    {
        print(id)
        sendMsgToPhone(onOff: 0, node: node)
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

