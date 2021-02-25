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
    
    struct Post: Codable , Identifiable{
        let id = UUID()
        var title: String
        var body: String
    }
    
    var access: HMHomeManager?
    
    init(){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
            print("fibaro stuff")
        }
        self.id = Int.random(in: 1..<9999)
        
    }
    
    init(observe: MQTTClient){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
        }

        self.id = Int.random(in: 1..<9999)
        self.observing = observe
        self.observing!.registerObserver(obs: self)

    }
    
    func test(){
        
        guard let url = URL(string : "http://130.240.114.44/api/devices/") else {return}
        var request = URLRequest(url: url)
        let encoding = "unicorn@ltu.se:jSCN47bC".data(using: .utf8)!.base64EncodedString()
        let auth = "Basic \(encoding)"
        request.setValue(auth , forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else {return}
            print(response)
        }
        task.resume()
        
        
        
    }
    
    //For responding to events from widefind, ie. code = "lämna kök" or something -> call for fibaro to turn off binary switches.
    //Todo: enum klass för alla event -> vad som ska bli kallat
    func moveEvent(code: String) {
        switch code{
            case "ankomst lägenhet":
                print("call func 1")
            case "lämnar lägenhet":
                print("call func 2")
            case "ankomst sovrum":
                print("call func 3")
            case "lämnar sovrum":
                print("call func 4")
            default:
                print("I feel a disturbance in the force.")
        }
        
    }
    
}
