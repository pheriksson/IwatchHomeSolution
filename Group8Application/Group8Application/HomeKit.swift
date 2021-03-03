//
//  HomeKit.swift
//  test
//
//  Created by roblof-8 on 2021-02-05.
//

import Foundation
import HomeKit
import SwiftUI


class Fibaro: MQTTObserver{
    var id : Int
    weak var observing : MQTTClient?
    
    private var encoding : String?
    private var url_base : String?
    private var nodeList : [nodeInfo] = [nodeInfo]()
    private var saveEnergyNodes: [Int]?
    
    struct Post: Codable , Identifiable{
        let id = UUID()
        var title: String
        var body: String
    }
    
    struct nodeInfo : Identifiable {
        let id = UUID()
        var nodeID: Int
        var name: String
        var type: String
        var value: Bool
    }
    
    var access: HMHomeManager?
    
    init(_ usr : String,_ pw : String,_ ip : String){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
            print("fibaro stuff")
        }
        self.id = Int.random(in: 1..<9999)
        
        //Fibaro base config.
        self.encoding = "\(usr):\(pw)".data(using: .utf8)!.base64EncodedString()
        self.url_base = "http://\(ip)/api/"
        
        self.saveEnergyNodes = []
        
        
    }
    
    init(_ usr : String,_ pw : String,_ ip : String, observe: MQTTClient){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
        }

        self.id = Int.random(in: 1..<9999)
        self.observing = observe
        self.observing!.registerObserver(obs: self)
        
        //Fibaro base config.
        self.encoding = "\(usr):\(pw)".data(using: .utf8)!.base64EncodedString()
        self.url_base = "http://\(ip)/api/"
        
        self.saveEnergyNodes = []
    }
    
    private func setupGetRequest(task : String) -> URLRequest{
        let url = URL(string : "\(url_base!)\(task)")
        let auth = "Basic \(encoding!)"
        
        var request = URLRequest(url : url!)
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    //OPERATIONAL
    private func getPowerLevel(dic : [String:Any]) -> Int{
        if (dic["type"] as! String == "com.fibaro.binarySwitch"){
            if let power = (dic["properties"] as! [String:Any])["power"] as? Double{
                if (power > 0){
                    return dic["id"] as! Int
                }
            }
        }
        return -1 //Need to change so that node with id = 0 does not ge
    }
    
    //OPERATIONAL.
    private func binarySwitchesConsumingEnergy(d : Data) -> [Int]{
        //let str = String(decoding: d, as: UTF8.self)
        var binarySwitches : [Int] = []
        if let oneBSwitch = try! JSONSerialization.jsonObject(with: d, options: []) as? [String:Any]{
            let nodeConsuming = self.getPowerLevel(dic: oneBSwitch)
            if(nodeConsuming != -1){
                binarySwitches.append(nodeConsuming)
            }
            return binarySwitches
        }
        if let multipleBSwitch = try! JSONSerialization.jsonObject(with: d, options: []) as? [[String:Any]]{
            for node in multipleBSwitch{
                let nodeConsuming = self.getPowerLevel(dic: node)
                if(nodeConsuming != -1){
                    binarySwitches.append(nodeConsuming)
                }
            }
        }
        return binarySwitches
    }
    
    private func turnOnClosedSwitches(){
        if saveEnergyNodes!.isEmpty{
            return
        }
        for node in self.saveEnergyNodes!{
            let request = self.setupGetRequest(task: "callAction?deviceID=\(node)&name=turnOn")
            let task = URLSession.shared.dataTask(with: request){(_, response, _) in
                guard let response = response else{return}
                if let respCode = response as? HTTPURLResponse{
                    if respCode.statusCode >= 400{
                        print("Node : \(node) failed to be turned on!")
                    }else{
                        print("Node : \(node) succeded in being turned on!")
                    }
                }
            }
            task.resume()
        }
        //Reset arr.
        self.saveEnergyNodes = []
        
    }
    //Strange behaviour inc if nodes alrdy existing in saveEnergyNodes.
    //Potentailly many fucking calls.
    private func turnOffConsumingSwitches(){
        let request = setupGetRequest(task: "devices/")
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            guard let data = data else{return}
            self.saveEnergyNodes = self.binarySwitchesConsumingEnergy(d: data)
            for consumingNode in self.saveEnergyNodes!{
                //Call to
                let request = self.setupGetRequest(task: "callAction?deviceID=\(consumingNode)&name=turnOff")
                let task = URLSession.shared.dataTask(with: request){(_, response, _) in
                    guard let response = response else {return}
                    if let respCode = response as? HTTPURLResponse{
                        print(respCode.statusCode)
                        if respCode.statusCode >= 400{
                            print("Node : \(consumingNode) failed to be turned off!")
                        }else{
                            print("Node : \(consumingNode) succeded in being turned off!")
                        }
                    }
                    
                }
                task.resume()
                //task: "callAction?deviceID=\(consumingNode)&name=turnOff"
            }
            
        }
        task.resume()
    }
    
    
    func refresh(){
        //let request = setupGetRequest(task: "devices?id=30")
        
        let request = setupGetRequest(task: "devices/")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {return}
            do {
                    var nodeID = -1
                    var name = ""
                    var type = ""
                    var value = false
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                
                        print(convertedJsonIntoDict[0])
                        /*for basenode in convertedJsonIntoDict
                        {
                            print(basenode)
                            /*
                            for node in basenode as! NSDictionary{
                                if node.key as? String == "id"
                                {
                                    nodeID = node.value as! Int
                                }
                                if node.key as? String == "name"
                                {
                                    name = node.value as! String
                                }
                                
                                if node.key as? String == "view"{
                                    
                                    
                                    
                                    // properties is of type Any Class, we need to downgrade it to Dictionary.
                                    var viewArray: NSArray
                                    viewArray = node.value as! NSArray
                                    for keys in viewArray[0] as! NSDictionary
                                    {
                                        if keys.key as! String == "name"
                                        {
                                            type = keys.value as! String
                                        }
                                    }
                                }
                                
                                
                                if node.key as? String == "properties"{
                                    // properties is of type Any Class, we need to downgrade it to Dictionary.
                                    var propertiesDict: NSDictionary
                                    propertiesDict = node.value as! NSDictionary
                                    for attribute in propertiesDict{
                                        let obj = attribute.key as? String
                                        if obj == "value" {
                                            value = attribute.value as! Bool
                                        }
                                    }
                                }
                            }
                        */}*/
                        let listEntry = nodeInfo(nodeID:nodeID, name:name, type:type, value:value)
                        print(listEntry)
                        self.nodeList.append(listEntry)
                        print(self.nodeList)
                    }
                
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        
                        
                        print(convertedJsonIntoDict)
                        for node in convertedJsonIntoDict{
                            if node.key as? String == "id"
                            {
                                nodeID = node.value as! Int
                            }
                            if node.key as? String == "name"
                            {
                                name = node.value as! String
                            }
                            
                            if node.key as? String == "view"{
                                
                                
                                
                                // properties is of type Any Class, we need to downgrade it to Dictionary.
                                var viewArray: NSArray
                                viewArray = node.value as! NSArray
                                for keys in viewArray[0] as! NSDictionary
                                {
                                    if keys.key as! String == "name"
                                    {
                                        type = keys.value as! String
                                    }
                                }
                            }
                            
                            
                            if node.key as? String == "properties"{
                                // properties is of type Any Class, we need to downgrade it to Dictionary.
                                var propertiesDict: NSDictionary
                                propertiesDict = node.value as! NSDictionary
                                for attribute in propertiesDict{
                                    let obj = attribute.key as? String
                                    if obj == "value" {
                                        value = attribute.value as! Bool
                                    }
                                }
                            }
                        }
                        let listEntry = nodeInfo(nodeID:nodeID, name:name, type:type, value:value)
                        print(listEntry)
                        self.nodeList.append(listEntry)
                        print(self.nodeList)
                    }
                }
                     catch let error as NSError {
                         print("catch let error")
                         print(error.localizedDescription)
                     }
            //let str = String(decoding: data, as: UTF8.self)
            print("kolla här\n\n\n\n\n\n\n\n\n\n\n\n")
            //print(type(of: str))
        }
        task.resume()
        
        
        
    }
    

    
    
    //For responding to events from widefind, ie. code = "lämna kök" or something -> call for fibaro to turn off binary switches.
    //Todo: enum klass för alla event -> vad som ska bli kallat
    func moveEvent(code: String) {
        switch code{
            case "entering appartement":
                print("Turning on previously closed consuming nodes...")
                turnOnClosedSwitches()
                print("call func 1")
            case "leaving appartement":
                print("Turning off consuming nodes...")
                turnOffConsumingSwitches()
                //saveEnergy()
            case "entering bedroom":
                //Function for checking if oven is opperating or if any "spis plattor" is active.
                print("call func 3")
            case "leaving bedroom":
                print("call func 4") //Currently not used
            case "entering kitchen":
                print("call func 5")
            case "leaving kitchen":
                print("call func 6") //Currently not used
            default:
                print("I feel a disturbance in the force, event: [\(code)] was called.")
        }
        
    }
    private func turnOnNodes(id : [Int]) -> Bool{return true}
    private func turnOffNodes(id : [Int]) -> Bool{return true}
    private func checkEnergyConsumption() -> [Int]?{return [0]}
    
    
    
    
    
    
}
