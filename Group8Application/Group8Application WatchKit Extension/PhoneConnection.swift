//
//  PhoneConnection.swift
//  Group8Application WatchKit Extension
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity


class PhoneConnection : NSObject, WCSessionDelegate{
    
    var session : WCSession!
    var view : lamp?
    
    override init(){
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }



    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Recieved following msg in watch:")
        //self.view = self.view?.getLampView()
        /*for(key,value) in message{
            print("Key: \(key) value: \(value)")
        }*/
        if let fibaroReq = message["FIBARO"] {
            print("HEJ")
            //self.view!.updateList(list: message["BODY"] as! [Dictionary<String,Any>])
            
        }
    }


    func send(msg : [String : Any]){
        if !(session.isReachable){
            print("bajs")
            return
        }
        
        session.sendMessage(msg, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })

    }
    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

}


