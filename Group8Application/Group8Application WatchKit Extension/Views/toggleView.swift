//
//  toggleView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-07.
//

import Foundation
import SwiftUI

struct ToggleView : View {
    
    @State var isChecked: Bool
    private var firstClick : prepLoad
   
    var phoneCon: PhoneConnection?
    let name: String?
    let id : Int?
    
    init(phoneCon : PhoneConnection, name : String, id : Int, status : Bool){
        self.phoneCon = phoneCon
        self.name = name
        self.id = id
        self.firstClick = prepLoad()
        if status
        {
            _isChecked = State(initialValue: true)
        }
        else {
            _isChecked = State(initialValue: false)
        }
    }
    
    var body: some View{
        
        Image(systemName: "lightbulb.fill").padding()
        Toggle(isOn: $isChecked) {
            Text("Node : \(id!)")
            HStack{
                
                if (!self.firstClick.getLoaded()){
                    Text("\(self.firstClick.setFinishedLoading())")
                    Text("first load")
                }
                else {
                    Text("2nd load")
                    /*
                    if isChecked {
                        Text("\(self.turnOn(node: self.id!))")
                    }
                    else{
                        Text("\(self.turnOff(node: self.id!))")
                    }*/
                }
            }
        }
    }

    //Turn on func
    func turnOn(node : Int) -> String
    {
        print("ON")
        sendMsgToPhone(onOff: 1, node: node)
        return ""
    }
    
    
    //Turn off
    func turnOff(node : Int) -> String
    {
        print("Off")
        sendMsgToPhone(onOff: 0, node: node)
        return ""
    }
    
    func sendMsgToPhone(onOff : Int, node : Int){
        
        guard let phoneCon = phoneCon else {return}
        
        var dic = [String : Any]()
        dic["FIBARO"] = true
        dic["CODE"] = onOff
        dic["NODE"] = node
        
        phoneCon.send(msg: dic)
        print("protocol FIBARO msg was created and sent")
    }
}

class prepLoad{

    var prep: Bool = false

    func setFinishedLoading() -> String{
        self.prep = true
        print("den e \(self.prep) nu")
        return ""
    }

    func getLoaded() -> Bool{
        return self.prep
    }
}

