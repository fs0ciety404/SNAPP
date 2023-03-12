//
//  SessionDelegator.swift
//  MC3
//
//  Created by Francesco De Stasio on 17/02/23.
//

import Foundation
import Combine
import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate , ObservableObject{
    
    private let session: WCSession
    var contObjects : [MyContact] = []
    @Published var receivedObjects : [MyContact] = []
    var lastMessage : CFAbsoluteTime = 0
    @Published var token: String?
    
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        
        #if os(iOS)
        print("iPhone: connection initialized")
        #endif
        
        #if os(watchOS)
        print("Watch: connection initialized")
        #endif
        
        self.connect()
    }
    
    func connect(){
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        session.activate()
        
    }
    
    func send(message : [String : Any]) -> Void{
        session.sendMessage(message, replyHandler: nil){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Protocol comformance only
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        print("Received Message")
        
        if(message["contObject"] != nil){
            let loadedData = message["contObject"]
            NSKeyedUnarchiver.setClass(MyContact.self, forClassName: "MyContact")
            
            let loadedPerson = try! NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClasses:
            [MyContact.self], from: loadedData as! Data) as? [MyContact]
            self.receivedObjects.append((loadedPerson?.first)!)
            print("program received")
        } else if(message["token"] != nil){
            self.token = message["token"] as? String ?? ""
            print("Token : " + self.token!)
        } else if(message["user_number"] != nil){
            UserDefaults.standard.set(message["user_number"], forKey: "user_number")
            print("User number: \(message["user_number"])")
        }
    }
    
    // iOS Protocol comformance
    // Not needed for this demo otherwise
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        
    }
    #endif
  

    func sendTokenToWatch(token : String) {
        if session.isReachable == true {
                let message = ["token": token]
                session.sendMessage(message, replyHandler: nil, errorHandler: nil)
            }
    }
    
    func sendContacts(contacts : [MyContact]){
        
        self.contObjects.removeAll()
        for contact in contacts {
            contObjects.append(contact)
            print(contact.numbers)
        }
        
        NSKeyedArchiver.setClassName("MyContact", for: MyContact.self)
        let data = try! NSKeyedArchiver.archivedData(withRootObject: contObjects, requiringSecureCoding: true)
        sendWatchMessage(data)
        
        if(session.isReachable == true){
            let number = ["user_number" : UserDefaults.standard.string(forKey: "user_number")]
            session.sendMessage(number, replyHandler: nil)
        }
    }
    
    
    public func isConnected() -> Bool{
        return session.isReachable
    }
    
    
    
    
    private func sendWatchMessage(_ msgData: Data){
        print("Sending message..")
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if lastMessage + 0.5 > currentTime{
            return
        }
        
        if(session.isReachable){
            let message = ["contObject" : msgData]
            session.sendMessage(message, replyHandler: nil)
        }
        
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
}
