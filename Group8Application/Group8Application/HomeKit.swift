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
        
    }
    
    private func setupGetRequest(task : String) -> URLRequest{
        let url = URL(string : "\(url_base!)\(task)")
        let auth = "Basic \(encoding!)"
        
        var request = URLRequest(url : url!)
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func test(){
        
        
        let request = setupGetRequest(task: "devices/?id=30")
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {return}
            do {
                    var nodeID = -1
                    var name = ""
                    var type = ""
                    var value = false
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        
                        
                        //print(type(of: convertedJsonIntoDict))
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
                        //nodeList.append(listEntry)
                              
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
                print("call func 1")
            case "leaving appartement":
                print("call func 2")
            case "entering bedroom":
                print("call func 3")
            case "leaving bedroom":
                print("call func 4")
            case "entering kitchen":
                print("call func 5")
            case "leaving kitchen":
                print("call func 6")
            default:
                print("I feel a disturbance in the force, event: [\(code)] was called.")
        }
        
    }
    
}
