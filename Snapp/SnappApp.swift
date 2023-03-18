//
//  SnappApp.swift
//  Snapp
//
//  Created by Francesco De Stasio on 10/03/23.
//

import SwiftUI
import CoreHaptics
import FirebaseCore
import FirebaseMessaging

public class DeviceTokenManager {
    private init() {}
    static let shared = DeviceTokenManager()
    
    var deviceToken : String?
    
}

class AppDelegate: UIResponder, UIApplicationDelegate{
    
    
    let gcmMessageIDKey = "gcm.Message_ID"
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
         let token = deviceToken
             .map { String(format: "%02.2hhx", $0)}
             .joined()
        
     }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
            FirebaseApp.configure()
            
            
            UNUserNotificationCenter.current().delegate = self

            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: { _, _ in }
            )

            application.registerForRemoteNotifications()
            
            //Messagging delegate
            Messaging.messaging().delegate = self
            
            return true
        }
}


@main
struct SnappApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)var appDelegate
    
    var supportsHaptics: Bool = false

    var body: some Scene {
        WindowGroup {
            SplashscreenViewIOS()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    

      // Receive displayed notifications for iOS 10 devices.
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification) async
        -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // ...
        //TODO: take the notification number and change it with the name of the contact
         //  let number = notification.request.content.title.suffix(9)
           
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.alert, .sound]]
      }

      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo

        // ...

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        print(userInfo)
      }
    
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }

    
}

extension AppDelegate: MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        DeviceTokenManager.shared.deviceToken = fcmToken
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
