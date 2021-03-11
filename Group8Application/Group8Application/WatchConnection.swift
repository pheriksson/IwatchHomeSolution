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
        
        //If get request sent from watch -> call that objects recMsgFromWatch!
        //Else (no data to return to watch) simply call requested function in respective object.
        
        
        if let fibaroReq = message["FIBARO"]{
            
            if let GET = message["GET"]{
                return self.fibaro!.recMsgFromWatch(code: message["CODE"] as! Int)
            }
            //If not get request -> post request, performe some action in the lab.
            switch message["CODE"] as! Int{
            case 0:
                //Code 0 -> turn off "NODE" binarySwitch.
                return self.fibaro!.turnOffSwitch(id: message["NODE"] as! Int)
            case 1:
                //Code 1 -> turn on "NODE" binarySwitch.
                self.fibaro!.turnOnSwitch(id: message["Node"] as! Int)
            default :
                print("No more actions to be taken for fibaro, call your lokal developper noob.")
            }
            
            return
            /*
            if message["Toggle"] as! Bool{
                print("Nu sätter vi på lampan")
                self.fibaro!.turnOnSwitch(id: message["Node"] as! Int)
            }
            else {
                print("Stänger av lampan")
                self.fibaro!.turnOffSwitch(id: message["Node"] as! Int)
            }*/
        }
        
        if let hueReq = message["HUE"]{
            if let GET = message["GET"]{
                return self.hue!.recMsgFromWatch(code: message["CODE"] as! Int)
            }
            //If not get request -> post request, perform some action in the lab.
            switch message["CODE"] as! Int{
            case 0:
                //Code 0 -> turn off "NODE" light.
                self.hue!.turnOffLight(light : message["NODE"] as! String)
            case 1:
                //Code 1 -> turn off "NODE" light.
                self.hue!.turnOnLight(light : message["NODE"] as! String)
            default:
                print("No more actions to be taken for philip hue, call your lokal developper noob.")
            }
            return
        }
        
        print("Recieved following msg in phone without a handler:")
        for (key,value) in message{
           print("Key: \(key) value: \(value)")
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
    
    
    
    
    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}

}


