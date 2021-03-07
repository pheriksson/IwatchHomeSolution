//
//  WatchConnection.swift
//  Group8Application
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity

class WatchConnection : NSObject, WCSessionDelegate{



    var session : WCSession!


    override init(){
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }

    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {

        if let fibaroReq = message["FIBARO"]{
            //Fibaro req recieved.
        }
        if let hueReq = message["HUE"]{
            //hue req recieved.
        }
        if let robReq = message["ROBOT"]{
            //robot req recieved.
        }

        if let testMsg = message["MSG"]{
            print("Recieved msg on phone \(testMsg)")
        }
    }


    func send(reqType : String, code : String){
        let message = [ reqType : code]
        session.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })
    }

    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}



}
