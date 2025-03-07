//
//  PhoneConnection.swift
//  Group8Application WatchKit Extension
//
//  Created by Sven Andersson on 2/28/21.
//

import Foundation
import WatchConnectivity



class PhoneConnection : NSObject, WCSessionDelegate, ObservableObject, Identifiable{
    
    private var notCreator : NotificationCreator!
    
    
    @Published var outletList : [Dictionary <String, Any>]

    @Published var outletDoorList : [Dictionary <String, Any>]
    private var tempFlag = false

    private var outlletFlag = false                 //So we do not get multiple instances of the same view reacting??

    var session : WCSession!
    //var view : lamp? Tar bort efter bekräftelse.
    
    var philipHueLights : HueContainer
    var fibBS : FibContainer
    
    init(notification : NotificationCreator){
        self.outletDoorList = [Dictionary<String, Any>]()

        self.outletList = [Dictionary<String, Any>]()
        self.philipHueLights = HueContainer()
        self.fibBS = FibContainer()
        super.init()
        if WCSession.isSupported(){
            self.session = WCSession.default
            self.session.delegate = self
            self.session.activate()
            self.notCreator = notification
        }
        /* USED FOR TESTING PHILIP HUE VIEW
        DispatchQueue.main.asyncAfter(deadline: .now()+10){
            self.philipHueLights.recieveHueLights(lights: ["LampID1337":1,"LampID80085":0 ])
        }
        */
        
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
                print("Fibaro message recieved")
                if let notification = message["NOTIFICATION"]{
                    //Switch here if we want to support different types off notification.
                    self.sendLocalNotification(body: notification as! String)
                    return
                }
                if let responseCode = message["CODE"]{
                    switch responseCode as! Int{
                    case 0:
                        print("Recieved msg from Fib in phoneConnection")
                        self.fibBS.recieveFibSwitches(lights: message["BODY"] as! [Dictionary<String, Any>])
                        print("fib container set")
                        //self.outlletFlag = true
                        //self.outletList = message["BODY"] as! [Dictionary<String, Any>]
                    //case 1:
                        //self.tempFlag = true
                        //self.outletDoorList = message["BODY"] as! [Dictionary<String, Any>]
                    default:
                        print("No more actions to be taken for fibaro with responseCode : \(responseCode as! Int) recieved in PhoneConnection")
                    }
                }
            }
                //<!--------------------- PHILIP HUE -------------------!>//
            if let hueReq = message["HUE"]{
                if let notification = message["NOTIFICATION"]{
                    //Inte satt ngn notification trigger för phue, 10:e mars.
                    print("HUE recieved")
                    self.sendLocalNotification(body: notification as! String)
                    return
                }
                if let responseCode = message["CODE"]{
                    switch responseCode as! Int{
                    case 0:
                        let recievedHue = message["BODY"] as! [String : Int]
                        print("Recieved msg from philip hue in phoneConnection")
                        for (key,value) in recievedHue{
                            print("Key \(key) value\(value)")
                        }
                        self.philipHueLights.recieveHueLights(lights: recievedHue) //Update hue lights
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
        for (key,value) in msg{
            print("SENDING KEY: \(key) Value: \(value)")
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
    
    public func getTempFlag() -> Bool {
        return tempFlag
    }
    
    public func resetOutletFlag(){
        self.outlletFlag = false
    }
//}
    
    func getHueContainer() -> HueContainer{
        return philipHueLights
    }
    
    func getFibContainer() -> FibContainer {
        return fibBS
    }

}

class HueContainer : ObservableObject{
    
    @Published var lights : [String : Int]
    private var lightStatus : Bool = false
    
    init(){
        self.lights = [String : Int]()
    }
    
    //Light id = key, status = value.
    func recieveHueLights(lights : [String : Int]){
        self.lightStatus = true
        self.lights = lights
    }
    
    func waitRefreshList(){
        self.lightStatus = false
    }
    
    func getHueLights() -> [String : Int]{
        return lights
    }
    
    func getHueLightStatus() -> Bool{
        return lightStatus
    }
}


// Fib container

class FibContainer : ObservableObject {
    @Published var lights : [Dictionary<String, Any>]
    private var lightStatus : Bool = false
    
    init(){
        self.lights = [Dictionary<String, Any>]()
    }
    
    //Light id = key, status = value.
    func recieveFibSwitches(lights : [Dictionary<String, Any>]){
        print("Setting recieveFibSwitches to true.")
        self.lightStatus = true
        print("Updating published list off switches.")
        self.lights = lights
        print("Published list off switches set")
    }
    
    func getFibSwitches() -> [Dictionary<String, Any>]{
        return lights
    }
    
    func getFibSwitchesStatus() -> Bool{
        return lightStatus
    }
}



