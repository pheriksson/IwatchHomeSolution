//
//  DoorView.swift
//  Group8Application WatchKit Extension
//
//  Created by roblof-8 on 2021-03-10.
//

import SwiftUI

struct DoorView: View {
    
    @ObservedObject var phoneCon: PhoneConnection
    
    init(phoneCone: PhoneConnection){
        self.phoneCon = phoneCone
        //self.sendMsgToPhone(code: 1)
    }
    var body: some View {
        if(phoneCon.getTempFlag()){
            let keys = phoneCon.outletList.map{$0.keys}
            let values = phoneCon.outletList.map{$0.values}
            
             
            VStack{
                ScrollView{
                    //let vadFanSomHellst = phoneCon.outletList as NSObject
                    ForEach(0..<phoneCon.outletList.count){ index in
                        HStack{
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
                    }
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
}
/*
struct DoorView_Previews: PreviewProvider {
    static var previews: some View {
        DoorView()
    }
}*/
