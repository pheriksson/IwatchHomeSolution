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
    tempItem(nodeID: 193, name: "Natt lampa", status: false)
    ]
    
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
    }
    
}
/*
struct lamp_Previews: PreviewProvider {
    static var previews: some View {
        lamp()
    }
}*/
