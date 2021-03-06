//
//  WatchConnection.swift
//  Group8Application
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity

class WatchConnection : NSObject, WCSessionDelegate, FibaroObserver, HueObserver{

    



    var session : WCSession!
    var fibaro : Fibaro?
    var hue : HueClient?


    init(fib : Fibaro, hue : HueClient){
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            print(session.activationState)
            self.fibaro = fib
            self.hue = hue
        }
        

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        if let fibaroReq = message["FIBARO"]{
            //self.fibaro!.recMsgFromWatch(code: fibaroReq as! Int)
            if message["Toggle"] as! Bool{
                print("Nu sätter vi på lampan")
                self.fibaro!.turnOnSwitch(id: message["Node"] as! Int)
            }
            else {
                print("Stänger av lampan")
                self.fibaro!.turnOffSwitch(id: message["Node"] as! Int)
            }
        }
        if let hueReq = message["HUE"]{
            self.hue!.recMsgFromWatch(code: hueReq as! Int)
        }else{
            print("Recieved following msg in phone without a handler:")
            for (key,value) in message{
                print("Key: \(key) value: \(value)")
            }
            
        }
    }

    //Send msg to watch for processing.
    func send(_ message : [String : Any]){
        if !(session.isReachable){
            return
        }
        session.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })
    }

    internal func fibNotification(_ msg :[String : Any]){
        print("Fib response recieved with the msg:")
        for(key,value) in msg{
            print("Key: \(key), value: \(value)")
        }
        /*
        DispatchQueue.main.async{
            self.send(msg)
        }
        */
    }
    
    func hueNotification(_ msg: [String : Any]) {
        print("Hue response recieved with the msg:")
        for(key,value) in msg{
            print("Key: \(key), value: \(value)")
        }
        /*
         DispatchQueue.main.async{
         self.send(msg)
         }
         
         */
    }
    
    
    
    
    /*private func hueNotification(_ msg : [String:Any]){
        print("Philips Hue response recieved with the msg \(msg["NOTIFICATION"] as String).")
        print("Sending said msg to watch for processing.")
        //Dispatch queue to wake phone up if in background state.
        DispatchQueue.maina.async{
            session.send(msg)
        }
     }
     */
    
    
    
    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}



}
