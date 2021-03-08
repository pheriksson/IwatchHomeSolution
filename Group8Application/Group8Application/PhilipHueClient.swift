//
//  PhilipHueClient.swift
//  Group8Application
//
//  Created by Sven Andersson on 3/5/21.
//

import Foundation

enum hueError : Error{
    case noDataAvailable
    case cannotProccessData
    case codeNotSupported
}

//Change Homekit devices query.
//Add events in mqtt client for when user enters appartement.

class HueClient : MQTTObserver{
    var observers : [HueObserver]
    var lights : [String:Int]
    private var ip : String
    private var usr : String
    private var url_base : String
    
    init(_ ip : String, _ usr : String = "newdeveloper"){
        self.lights = [String:Int]()
        self.ip = ip
        self.usr = usr
        self.url_base = "http://\(ip)/api/\(usr)/"
        self.observers = [HueObserver]()
    }
    
    private func setupGetRequest(task : String) -> URLRequest{
        let url = URL(string : "\(self.url_base)\(task)")
        var request = URLRequest(url : url!)
        request.httpMethod = "GET"
        return request
    }
    
    func test() {
        //updateLights()
        //var test = watchGetLights()
        //self.printLights()
        //turnOnLight(light: "13")
        //turnOnLight(light: "14")
        //turnOnLight(light: "15")
        //turnOffLight(light: "13")
        //turnOffLight(light: "14")
        //turnOffLight(light: "15")
    }
    
    func parseLights(d : Data) -> [String : Int]{
        var lightStatus = [String:Int]()
        if let lights = try! JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary{
            for light in lights{
                if let status = ((light.value as! NSDictionary)["state"] as! NSDictionary)["on"]{
                    lightStatus[(light.key as! String)] = (status as! Int)
                }
            }
        }
        return lightStatus
    }
    func printLights(){
        print("Starting print lights")
        for (key,val) in self.lights{
            print("Key: \(key), val : \(val)")
        }
    }
    
    func watchGetLights() -> Void{
        self.updateLightsHelper(completion:{ [weak self] result -> Void in
            switch result{
            case .failure(let error):
                print(error)
            case .success(var lights):
                //Update state of lights, awkward casting .... improve might be to change light status to String : Any ....
                self?.lights = lights
                self!.notifyObservers(lights as [String : Any])
                
            }
        })
    }
    
    func updateLightsHelper(completion : @escaping(Result<[String : Int], hueError>) -> Void){
        let request = setupGetRequest(task: "lights")
        let task = URLSession.shared.dataTask(with: request){(data, _, _) in
            guard let data = data else{
                completion(.failure(.noDataAvailable))
                return
            }
            let response = self.parseLights(d: data)
            completion(.success(response as [String : Int]))
            
            
            //self.lights = self.parseLights(d: data)
        }
        task.resume()
    }
    //Turn on/off practicaly the same,
    func turnOnLight(light : String){
        switchLightState(light : light, onoff : true)
    }
    
    func turnOffLight(light : String){
        switchLightState(light : light, onoff: false)
    }
    
    func switchLightState(light : String, onoff : Bool){
        let body = ["on":onoff]
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        //prep rest of request.
        let url = URL(string : "\(self.url_base)lights/\(light)/state")
        var request = URLRequest(url : url!)
        request.httpMethod = "PUT"
        request.httpBody = jsonBody

        //Send request.
        let task = URLSession.shared.dataTask(with: request){(_, response, _) in
            guard let response = response else{return}
            if let respCode = response as? HTTPURLResponse{
                print("Task switch light ended with response: \(respCode.statusCode)")
            }
        }
        task.resume()
    }
    
    func moveEvent(code: String) {
        switch code{
        case "entering appartement":
            print("Entering appartement call recieved in philips hue")
            print("Calling send msg to watch through philip hue for testing")
            watchGetLights()
        case "leaving appartement":
            print("Leaving appartement call recieved in philips hue")
        case "entering kitchen":
            print("Entering kitchen call recieved in philips hue")
        case "leaving kitchen":
            print("Leaving kitchen call recieved in philips hue")
        case "entering bedroom":
            print("Entering bedroom call recieved in philips hue")
        case "leaving bedroom":
            print("Leaving bedroom call recieved in philips hue")
        default:
            print("Unknown code of \(code) recieved in philips hue instance.")
        
        }
    }
    
    //Get request sent from watch controller, ie send something back.
    func recMsgFromWatch(code : Int){
        print("Watch controller wants philip hue to perform task \(code)")
        switch code{
        case 0:
            print("Case 0: Return list of all lights to watchConnection handler")
            watchGetLights()
        case 0:
            print("Case 0")
        case 0:
            print("Case 0")
        case 0:
            print("Case 0")
        default:
            print("Recieved \(code) from watch - not supported")
            //throw hueError.codeNotSupported
        
        
        
        }
    }
    
    
    func registerObserver(obs : HueObserver){
        observers.append(obs)
    }
    
    private func notifyObservers(_ msg : [String : Any]){
        print("Notifying observers of msg from philip hue:")
        for (x,y) in msg{
            print("Node: \(x) status : \(y)")
        }
        var setHeaderMsg = msg; setHeaderMsg["HUE"] = true
        for obs in observers{
            obs.hueNotification(setHeaderMsg)
        }
        
    }
}

//Göra klass för alla observables kanske ist för en för varje typ då alla är ungefär samma

protocol HueObserver{
    func hueNotification(_ msg : [String : Any]) -> Void
}




