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
    var view : lamp?
    
    //override init(){
        
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
            
            print("Recieved following msg in watch:")
            //self.view = self.view?.getLampView()
            /*for(key,value) in message{
                print("Key: \(key) value: \(value)")
            }*/
            if let fibaroReq = message["FIBARO"] {
                switch message["CODE"] as! Int{
                case 0:
                    self.outlletFlag = true
                    self.outletList = message["BODY"] as! [Dictionary<String, Any>]
                    //print("coolt")
                    //Code 0 -> turn off "NODE" binarySwitch.
                    //return self.fibaro!.turnOffSwitch(id: message["NODE"] as! Int)
                default :
                    print("No more actions to be taken for fibaro, call your lokal developper noob.")
                }
                print("HEJ")
                
                
                
                //self.view!.updateList(list: message["BODY"] as! [Dictionary<String,Any>])
                
            }
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
    
    public func getOutletFlag() -> Bool
    {
        return outlletFlag
    }
//}

}
