//
//  lamp.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-05.
//

import SwiftUI

struct lamp: View {
    
    public struct tempItem: Identifiable{
        let id = UUID()
        let nodeID : Int
        let name : String
        var status : Bool
    }
    
    // connection reference
    var phoneCon: PhoneConnection?
    
    // nodeList
    private var tempList: [tempItem] = [
    tempItem(nodeID: 198, name: "Lampa", status: false),
    tempItem(nodeID: 193, name: "Nattlampa", status: false)
    ]
    //@State private var tempList = [tempItem]()
    
    init(phoneCon : PhoneConnection){
        self.phoneCon = phoneCon
        
    }

    
    var body: some View {
        VStack{
            ScrollView{
                
                ForEach(tempList){ tempNode in
                    HStack{
                        // Send session object to phone to change the value of the obj to true
                        ToggleView(phoneCon: self.phoneCon!, name: tempNode.name, id: tempNode.nodeID, status: tempNode.status)
                        
                
                    } // HStack end
                }
            }
        } //Vstack end
        .onAppear(){
            self.sendMsgToPhone(code: 2)
        }
    }
 
    
    
    
    func sendMsgToPhone(code : Int){
        
        guard let phoneCon = phoneCon else {return}
        
        var dic = [String : Any]()
        dic["FIBARO"] = true
        dic["CODE"] = code
        //print(dic["CODE"])
        
        phoneCon.send(msg: dic)
        print("protocol FIBARO msg was created and sent")
    }
    
    public func getLampView() -> lamp
    {
        print("Ger referensen till lamp")
        return self
    }
    /*
    public func updateList(list : [Dictionary<String, Any>])
    {
        for node in list {
            let id : Int
            let name : String
            let value : Bool
            
            if node.keys as! String == "nodeID" {
                
            }
            let tempNode = tempItem(nodeID: node["nodeID"], name: node["name"], status: node["value"])
            tempList.append(tempItem(nodeID: node["nodeID"], name: node["name"], status: node["value"]))
        }
        print("Uppdate list")
    }*/
}




/*
struct lamp_Previews: PreviewProvider {
    static var previews: some View {
        lamp()
    }
}*/
