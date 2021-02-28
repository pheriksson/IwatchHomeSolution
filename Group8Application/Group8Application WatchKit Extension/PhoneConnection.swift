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

    override init(){
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
        }
    }



    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let notificationMsg = message["NOTIFICATION"]{
            //Notification recieved.
        }
        if let testMsg = message["MSG"]{
            print("Recieved test msg on watch: \(testMsg)")
        }
    }


    func send(reqType : String, msg : String){
        let message = [ reqType : msg]
        session.sendMessage(message, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })

    }
    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

}


