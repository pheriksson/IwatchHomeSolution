//
//  WatchConnection.swift
//  Group8Application
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity

class WatchConnection : NSObject, WCSessionDelegate, FibaroObserver{



    var session : WCSession!
    var fibaro : Fibaro?
    //var hue : PhilipHue?


    override init(fib : Fibaro){
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            self.fibaro = fib
            //self.hue = philHue
        }

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        if let fibaroReq = message["FIBARO"]{
            self.fibaro!.recMsgFromWatch(fibaroReq as Int)
        }
        if let hueReq = message["HUE"]{
            //hue req recieved.
            //self.hue!.recMsgFromWatch(hueReq as Int)
        }
        if let robReq = message["ROBOT"]{
            //robot req recieved.
        }

        if let testMsg = message["MSG"]{
            print("Recieved msg on phone \(testMsg)")
        }
    }

    //Send msg to watch for processing.
    func send(message : [String : Any]){
        if !(session.isReachable()){
            return
        }
        session.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })
    }

    private func fibNotification(_ msg :[String : Any]){
        print("Fibaro response recieved with the msg \(msg["NOTIFICATION"] as String).")
        print("Sending said msg to watch for processing.")
        //Dispatch queue to wake phone up if in background state.
        DispatchQueue.main.async{
            session.send(msg)
        }
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
