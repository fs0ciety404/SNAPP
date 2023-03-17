//
//  NotificationService.swift
//  MC3
//
//  Created by Francesco De Stasio on 03/03/23.
//


import UserNotifications
import UIKit

class NotificationService: NSObject, UNUserNotificationCenterDelegate, ObservableObject{
    override init() {
        super.init()
    }
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if let error = error {
                    print(error)
                } else if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    } 
                }
            }
    }
    //foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        logContents(of: notification)
        
        completionHandler([.badge, .sound, .banner])
    }
    //background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        logContents(of: response.notification)
        completionHandler()
    }
    
    func logContents(of notification: UNNotification){
        
        print(notification.request.content.userInfo)
    }
}
