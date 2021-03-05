//
//  testApp.swift
//  test WatchKit Extension
//
//  Created by Robin Olofsson on 2021-01-28.
//

import SwiftUI

@main
struct testApp: App {
    
    var phoneCon: PhoneConnection?
    var healthStore: HealthStoreWatch?
    
    init() {
        self.healthStore = HealthStoreWatch()
        self.phoneCon = PhoneConnection()
    }
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(healthStore: healthStore!, phoneCon: phoneCon!)
            }
        }
        

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
