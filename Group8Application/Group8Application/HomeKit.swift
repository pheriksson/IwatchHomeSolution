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
    private var observers : [FibaroObserver]
    
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
        }
        self.id = 80085
        
        //Fibaro base config.
        self.encoding = "\(usr):\(pw)".data(using: .utf8)!.base64EncodedString()
        self.url_base = "http://\(ip)/api/"
        
        self.observers = [FibaroObserver]()
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
    
    
    private func getPowerLevel(dic : [String:Any]) -> Int{
        // Limit for bug testing, remove when rdy.
        if(dic["roomID"] as! Int != 220){return -1}
        //
        
        if let power = (dic["properties"] as! [String:Any])["power"] as? Double{
            if (power > 0){
                return dic["id"] as! Int
            }
        }
        return -1 //Node does not consume energy
    }
    
    
    private func binarySwitchesConsumingEnergy(d : Data) -> [Int]{
        var binarySwitches : [Int] = []
        if let oneBSwitch = try! JSONSerialization.jsonObject(with: d, options: []) as? [String:Any]{
            let nodeConsuming = self.getPowerLevel(dic: oneBSwitch)
            if(nodeConsuming >= 0){
                binarySwitches.append(nodeConsuming)
            }
            return binarySwitches
        }
        if let multipleBSwitch = try! JSONSerialization.jsonObject(with: d, options: []) as? [[String:Any]]{
            for node in multipleBSwitch{
                let nodeConsuming = self.getPowerLevel(dic: node)
                if(nodeConsuming >= 0){
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
                        print("Node : \(node) failed to be turned on!") //Remove printouts on release
                    }else{
                        print("Node : \(node) succeded in being turned on!")
                    }
                }
            }
            task.resume()
        }
        saveEnergyNodes = []
        
    }
    //Strange behaviour inc if nodes alrdy existing in saveEnergyNodes.
    //Potentailly many fucking calls.
    private func turnOffConsumingSwitches(){
        let request = setupGetRequest(task: "devices?type=com.fibaro.binarySwitch")
        let task = URLSession.shared.dataTask(with: request){(data, response, error) in
            guard let data = data else{return}
            self.saveEnergyNodes = self.binarySwitchesConsumingEnergy(d: data)
            for consumingNode in self.saveEnergyNodes!{
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
            }
            
        }
        task.resume()
    }
    
    
    func getBinarySwitches(){
        //let request = setupGetRequest(task: "devices?id=30")
        
        //let request = setupGetRequest(task: "devices/")
        
        let request = setupGetRequest(task: "devices?type=com.fibaro.binarySwitch")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {return}
            do {
                    var nodeID = -1
                    var name = ""
                    var type = "com.fibaro.binarySwitch"
                    var value = false
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                
                        print(convertedJsonIntoDict)
                        for basenode in convertedJsonIntoDict
                        {
                            print(basenode)
                            
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
                            let listEntry = nodeInfo(nodeID:nodeID, name:name, type:type, value:value)
                            self.nodeList.append(listEntry)
                        }
                        //let listEntry = nodeInfo(nodeID:nodeID, name:name, type:type, value:value)
                        //print(listEntry)
                        //self.nodeList.append(listEntry)
                        /*for node in self.nodeList {
                            print("Nodens id: " + String(node.nodeID) + " | Nodens value " + String(node.value))
                            print(self.nodeList.count)
                        }*/
                    }
                }
                     catch let error as NSError {
                         print("catch let error")
                         print(error.localizedDescription)
                     }
        }
        task.resume()

    }
    
    func turnOnSwitch(id: Int)
    {
        let request = setupGetRequest(task: "callAction?deviceID=" + String(id) + "&name=turnOn")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        }
        task.resume()
    }
    func turnOffSwitch(id: Int)
    {
        let request = setupGetRequest(task: "callAction?deviceID=" + String(id) + "&name=turnOff")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
        }
        task.resume()
        
    }
    
    private func checkOven() -> Void{
        //device id 267 -> oven in current fibaro configuration.
        let request = setupGetRequest(task: "energy/now-3600/now/compare/devices/power/267")
        let task = URLSession.shared.dataTask(with: request){(data, _, _) in
            guard let data = data else {return}
            if self.checkOvenParse(data){
                let msg = ["FIBARO":true, "NOTIFICATION":"ALERT OVEN"] as [String : Any]
                self.notifyObservers(msg: msg)
            }
            
        }
        task.resume()
    }
    
    private func checkOvenParse(_ data : Data) -> Bool{
        if let oven = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]{
            for onlyOne in oven{
                if ((onlyOne["W"] as! NSNumber).intValue > 0){
                    return true
                }
            }
        }
        return false
    }
    
    
    //Get request sent from watch controller, ie send something back.
    func recMsgFromWatch(code : Int){
        //Setup response msg to watch.
        var watchResponse = [String : Any]()
        watchResponse["FIBARO"] = true
        
        switch code{
        case 0:
            //prep response with status of all binary switches.
            print("Fibaro recieved call from watch to send status of all binary switches to watch")
        case 1:
            print("Fibaro recieved call from watch to send status of all doors to watch")
            //prep response with status of all doors.
        default:
            print("Fibaro recieved code: \(code) from watch, somethings fucky.")
        }
    }
    //Go over events in MQTTClient, mroe events should be called...
    func moveEvent(code: String) {
        switch code{
            case "entering appartement":
                print("Entering appartement event in fibaro")
                print("Turning on previously closed consuming nodes...")
                turnOnClosedSwitches()
                
            case "leaving appartement":
                print("Leaving appartement event in fibaro")
                print("Turning off consuming nodes...")
                turnOffConsumingSwitches()

            case "entering bedroom":
                print("Entering bedroom event in fibaro")
                print("CheckOven called.")
                checkOven()

            case "leaving bedroom":
                print("Leaving bedroom event in fibaro")

            case "entering kitchen":
                print("Entering kitchen event in fibaro")
                
            case "leaving kitchen":
                print("Leaving kitchen event in fibaro")
            default:
                print("I feel a disturbance in the force, event: [\(code)] was called.")
        }
        
    }
    
    func registerObserver(obs : FibaroObserver){
        observers.append(obs)
    }
    
    private func notifyObservers(msg : [String : Any]){
        print("Notifying observers of msg from Fibaro:")
        for (key,value) in msg{
            print("Key: \(key) value: \(value)")
        }
        for obs in observers{
            obs.fibNotification(msg)
        }
    }
}




protocol FibaroObserver{
    func fibNotification(_ msg : [String : Any]) -> Void
}
