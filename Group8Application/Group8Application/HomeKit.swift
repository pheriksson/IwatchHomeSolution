//
//  HomeKit.swift
//  test
//
//  Created by roblof-8 on 2021-02-05.
//

import Foundation
import HomeKit
import SwiftUI
class Fibaro{
    struct Post: Codable , Identifiable{
        let id = UUID()
        var title: String
        var body: String
    }
    var access: HMHomeManager?
    
    init(){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
            print("fibaro stuff")
        }
    }
    
    func test(){
        guard let url = URL(string: "http://unicorn@ltu.se:jSCN47bC@130.240.114.44/api/devices/") else{return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else{print("skiten är nil, fel på data"); return }
            let posts = try! JSONDecoder().decode([Post].self, from: data)
            print(posts)
        }
        .resume()
        
    }
    
    
}
