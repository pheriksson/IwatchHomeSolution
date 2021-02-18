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
    var access: HMHomeManager?
    
    init(){
        if (HMHomeManager.accessibilityActivate()) {
            access = HMHomeManager()
            print("fibaro stuff")
        }
    }
    
    
}
