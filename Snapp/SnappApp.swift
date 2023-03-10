//
//  SnappApp.swift
//  Snapp
//
//  Created by Francesco De Stasio on 10/03/23.
//

import SwiftUI
import CoreHaptics


public class DeviceTokenManager {
    private init() {}
    static let shared = DeviceTokenManager()
    
    var deviceToken : String?
    
}

class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken
            .map { String(format: "%02.2hhx", $0)}
            .joined()
        
        DeviceTokenManager.shared.deviceToken = token
        
    }
}


@main
struct SnappApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)var appDelegate
    
    var supportsHaptics: Bool = false
    @State var notificationService = NotificationService()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    notificationService.requestPermission()
                }
                .edgesIgnoringSafeArea(.all)
        }
    }
}
