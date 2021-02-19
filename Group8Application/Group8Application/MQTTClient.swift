//
//  MQTTClient.swift
//  Group8Application
//
//  Created by Sven Andersson on 2/19/21.
//

import Foundation
import CocoaMQTT


class MQTTClient{
    
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
        //self.con.logLevel = .debug
        
        self.pos = [0,0,0]
        self.con.delegate = self
        self.con.connect()
    }
    
    func get_post() -> [Int]{
        return self.pos!
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
                
            }
        }
     }
     
     func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("subscribed: \(success), failed: \(failed)")
     }
     
     func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("DIDPING")
     }
     
     func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("RECIEVEPING")
     }

     func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("DISCONNECTED")
     }
    
    
    
    //Not used.
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {}
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16){}
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {}
    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {}
    
}
