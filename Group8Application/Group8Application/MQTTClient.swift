//
//  MQTTClient.swift
//  Group8Application
//
//  Created by Sven Andersson on 2/19/21.
//

import Foundation
import CocoaMQTT

//TODO: Need to subscribe to specific tag, so that we do not get multiple readings.


class MQTTClient{
    
    var observers: [MQTTObserver]?
    var con: CocoaMQTT
    var host: String
    var port: UInt16
    var clientID: String
    var pos: [Int]?
    
    init(_ host: String, _ port: UInt16, _ clientID: String){
        //Saving address incase of disconnects.
        self.host = host
        self.port = port
        self.clientID = clientID
        self.con = CocoaMQTT(clientID: self.clientID, host: self.host, port: self.port)
        self.con.keepAlive = 60
        self.observers = [MQTTObserver]()
        self.pos = [0,0,0]
        self.con.delegate = self
        self.con.connect()
        
        
        //self.con.logLevel = .debug
    }
    
    func get_post() -> [Int]{
        return self.pos!
    }
    
    //TODO: Find a way to check if observers are alrdy in observers, duplicate observers will suck.
    func registerObserver(obs : MQTTObserver){
        if var arr = observers {
            arr.append(obs)
        }
    }
    
    //Notify all observers of specific event,
    func notifyObservers(event : String ){
        if let arr = observers{
            for obs in arr{
                obs.moveEvent(code: event)
            }
        }
    }
    
    
}



extension MQTTClient: CocoaMQTTDelegate{
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        for topic in topics{
            print(topic)
        }
    }
    
     
     func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .accept{
            mqtt.subscribe("#", qos: CocoaMQTTQOS.qos0)
            return
        }
        print("Failed to establish connection...")
     }
     

     
     func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let upperRange = message.string!.description.range(of: "REPORT:"){
            if let lowerRange = message.string!.description.range(of: "source"){
                let msg = message.string!.description[upperRange.upperBound...lowerRange.lowerBound].components(separatedBy: ",");
                //msg[2,3,4] = x,y,z
                self.pos![0] = Int(msg[2]) ?? 0
                self.pos![1] = Int(msg[3]) ?? 0
                self.pos![2] = Int(msg[4]) ?? 0
                
                //Todo, check state -> call observers depending on state change
                
                //print("x: \(self.pos![0]) y: \(self.pos![0]) z: \(self.pos![0])")
                //if self.pos![0] < 2000{
                //    self.notifyObservers(event: "CALL FROM WIDEFIND THAT X < 2000")
                //}
                
                
            }
        }
     }
     
     func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("subscribed: \(success), failed: \(failed)")
     }
     
     //Call recconnect on missed ping from certain intervall ??
     func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("RECIEVED PING")
     }
     //Call reconnect??
     func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("DISCONNECTED")
        //Raise error
     }
    
    
    
    //Not used.
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {}
    func mqttDidPing(_ mqtt: CocoaMQTT) {}
    
}



protocol MQTTObserver{
    let id: Int {get}
    //When certain location is registered, call move event.
    func moveEvent(code : String)
}
