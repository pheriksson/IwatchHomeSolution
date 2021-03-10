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
    @ObservedObject var phoneCon: PhoneConnection

    
    // nodeList
    private var tempList: [tempItem] = [
    tempItem(nodeID: 198, name: "Lampa", status: false),
    tempItem(nodeID: 193, name: "Nattlampa", status: false)
    ]
    //@State private var tempList = [tempItem]()
    
    init(phoneCon : PhoneConnection){
        self.phoneCon = phoneCon
        print("lamp init")
        self.sendMsgToPhone(code: 0)
    }
    
    var body: some View {
        //.onAppear(){
          //  self.sendMsgToPhone(code: 2)
        //}
        if(phoneCon.getOutletFlag()){
          //  Text("\(self.callReset())")
            //let keys = phoneCon.outletList.map{$0.keys}
            //let values = phoneCon.outletList.map{$0.values}
            
            //Text("\(values[1])")
            VStack{
                ScrollView{
                    let list = phoneCon.outletList as NSArray
                    ForEach(0..<list.count){ index in
                        //HStack{
                            let dic = list[index] as! NSDictionary
                            ToggleView(phoneCon: self.phoneCon, name: dic.value(forKey: "name") as! String, id: dic.value(forKey: "nodeID") as! Int, status: dic.value(forKey: "value") as! Bool)
                            /*ForEach(0..<test.count){i in
                                Text("\(test.value(forKey: "type") as! String)")
                            }*/
                            //Text("\(test.count)")
                       // }
                    }
                    
                    /*ForEach(0..<phoneCon.outletList.count){ index in
                        HStack{
                            //Text(keys[index])
                          //  if let x = vadFanSomHellst[index] as! [String: Any], let sub = x["type"] as! String{
                            //    Text("\(sub)")
                            //}
                            //{Text("\(x)")}
                            //Text("\(x)")
                            //var name = vadFanSomHellst[index]
                            Text("hej")
                            //Text(self.phoneCon.outletList[index])
                            // Send session object to phone to change the value of the obj to true
                            //ToggleView(phoneCon: self.phoneCon!, name: values[0], id: values[1], status: values[2])
                            
                    
                        } // HStack end
                    }*/
                }
            } //Vstack end
        }// if end
        else{
            Text("vi laddar data")
            Image(systemName: "hourglass")
        }
    }
    
    func sendMsgToPhone(code : Int){
        var msg = [String : Any]()
        msg["FIBARO"] = true
        msg["GET"] = true
        msg["CODE"] = code
        phoneCon.send(msg: msg)
        print("protocol FIBARO msg was created and sent")
    }
    //Används??
    public func getLampView() -> lamp
    {
        print("Ger referensen till lamp")
        return self
    }
    
    func callReset(){
        self.phoneCon.resetOutletFlag()
    }
    
    /*public func updateList(list : [Dictionary<String, Any>])
    {
        for node in list {
            let id : Int
            let name : String
            let value : Bool
            
            print("HEJ IGEN!!!")
            if node.keys as! String == "nodeID" {
                
            }
            //let tempNode = tempItem(nodeID: node["nodeID"], name: node["name"], status: node["value"])
            //tempList.append(tempItem(nodeID: node["nodeID"], name: node["name"], status: node["value"]))
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
