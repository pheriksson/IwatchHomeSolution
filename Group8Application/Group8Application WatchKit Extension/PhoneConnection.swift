//
//  PhoneConnection.swift
//  Group8Application WatchKit Extension
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity



class PhoneConnection : NSObject, WCSessionDelegate, ObservableObject, Identifiable{
    
    @Published var outletList : [Dictionary <String, Any>]
    private var outlletFlag = false
    var session : WCSession!
    //var view : lamp? Tar bort efter bekräftelse.
    var notCreator : NotificationCreator!

    init(notification : NotificationCreator){
        self.outletList = [Dictionary<String, Any>]()
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            self.notCreator = notification
        }
    }
    //Used for sending notifications recieved from phone.
    func sendLocalNotification(_ title: String = "Grp8Application",_ subtitle: String = "Warning", body: String){
        if let notificationCreater = self.notCreator{
            notificationCreater.createNotification(title: title, subtitle: subtitle, body: body, badge: 0)
            //Change badge to increament
        }
    }


    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            /*
            print("Recieved following msg in watch:")
            for(key,value) in message{
                print("Key: \(key) value: \(value)")
            }
            */
            
                //<!--------------------- FIBARO -------------------!>//
            if let fibaroReq = message["FIBARO"] {
                if let notification = message["NOTIFICATION"]{
                    //Switch here if we want to support different types off notification.
                    self.sendLocalNotification(body: notification as! String)
                }
                if let responseCode = message["CODE"]{
                    switch responseCode as! Int{
                    case 0:
                        self.outlletFlag = true
                        self.outletList = message["BODY"] as! [Dictionary<String, Any>]
                    case 1:
                        print("Doors to be implemented")
                    default:
                        print("No more actions to be taken for fibaro with responseCode : \(responseCode as! Int) recieved in PhoneConnection")
                    }
                }
            }
                //<!--------------------- PHILIP HUE -------------------!>//
            if let hueReq = message["HUE"]{
                if let notification = message["NOTIFICATION"]{
                    //Switch here if we want to support different types off notifications.
                    self.sendLocalNotification(body: notification as! String)
                }
                if let responseCode = message["CODE"]{
                    switch responseCode as! Int{
                    case 0:
                        let recievedHue = message["BODY"] as! [String : Any]
                        print("Recieved msg from philip hue in phoneConnection")
                        for (key,value) in recievedHue{
                            print("Key \(key) value\(value)")
                        }
                        //Set view for philipHueSwitches.
                        print("Setup view for philipHue lights")
                    default:
                        print("No more actions to be taken for hue with responseCode : \(responseCode as! Int) recieved in PhoneConnection")
                
                    }
                }
            }
        }
    }


    func send(msg : [String : Any]){
        if !(session.isReachable){
            return
        }
        session.sendMessage(msg, replyHandler: nil, errorHandler: {
            error in
            print(error.localizedDescription)
        })

    }
    //To be implemented.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    public func getOutletFlag() -> Bool{
        return outlletFlag
    }
//}

}
