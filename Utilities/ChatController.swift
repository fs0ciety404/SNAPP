//
//  ChatController.swift
//  MC3
//
//  Created by Francesco De Stasio on 01/03/23.
//

import Foundation
import CloudKit
import SwiftUI


let id_sender = "Id_sender"
let id_receiver = "Id_receiver"
let message_record_type = "Message"
let message_data = "Message_Data"


let user_record_type = "User"
let user_token = "User_token"
let user_number = "User_number"

let key_server = "AAAASU2TzNQ:APA91bHZlT_cGiuFv3DzpQLTwgrHGbvcIpIQXden_EHsZqZ8Rm5WHWI3yhIvclHgBdbp2u-O6m4OX9o3KQrCxSX7XK2k2lheStwWPP9Bq3M4Lq6so3Yf8ellioFukEqFjIssFQUp-ZY-"

class ChatController{
    
    @Published var isSignedInToiCloud = true
    @Published var error = ""
    @Published var cloudResult = ""
    
    public func saveUser(user : User, result: Binding<Bool>){
        
        UserDefaults.standard.set(user.number, forKey: "user_number")
            
            let database = CKContainer(identifier: "iCloud.ICLOUD.SNAPP").publicCloudDatabase
            let record = CKRecord(recordType: user_record_type)
            record.setValue(user.getToken() , forKey: user_token)
            record.setValue(user.getNumber(), forKey: user_number)
            
            var retString = ""
            database.save(record) { (savedRecord, error) in
                if let error = error {
                    print("Errore durante il salvataggio del record: \(error.localizedDescription)")
                    retString = "\(error.localizedDescription)"
                    self.isSignedInToiCloud = false
                    self.error = retString
                    result.wrappedValue = true
                    self.cloudResult = error.localizedDescription
                } else {
                    print("Record salvato con successo con ID: \(savedRecord!.recordID.recordName)")
                    result.wrappedValue = true
                    self.cloudResult = NSLocalizedString(".record_saved", comment: "comment")
                }
            }
        }
    
    public func sendNotification(to number: String, sent: Binding<Bool>, showError: Binding<Bool>){
        let database = CKContainer(identifier: "iCloud.ICLOUD.SNAPP").publicCloudDatabase
        let predicate = NSPredicate(format: user_number + " == %@", number)
        let query = CKQuery(recordType: "User", predicate: predicate)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Errore durante l'esecuzione della query: \(error.localizedDescription)")
                self.error = error.localizedDescription
                showError.wrappedValue = true
            } else if let records = records {
             
                if records.isEmpty{
                    self.error = " Your contact is not registered with the app"
                    showError.wrappedValue = true
                }else{
                    
                    let token  = records.first?.value(forKey: user_token) as! String
                    
                                
                    var snapped = NSLocalizedString(".you_are_being_snapped_by" , comment: "comment")
                    
                   //append the name and number
                    let number =  UserDefaults.standard.string(forKey: "user_number")
                    snapped.append(number ?? "unknown")
                    let aboutYou = NSLocalizedString(".im_thinking_about_you", comment: "comment")
                    
                    // prepara il payload della notifica push
                    self.sendPushNotification(to: token, title: snapped.description, body: aboutYou.description, sent: sent, showError: showError)
                    
                    
                    print("Records recuperati con successo: \(records)")
                    self.error = ""
                }
            }
        }
    }
    
    private func sendPushNotification(to token: String, title: String, body: String, sent: Binding<Bool>, showError: Binding<Bool>)  {
        let message = ["title": title,
                       "body": body]
        
        // Token del dispositivo di destinazione
        
        
        // Impostazioni della notifica push
        let notification = ["notification": message,
                            "to": token] as [String : Any]
        
        // Converti la notifica in formato JSON
        let jsonData = try? JSONSerialization.data(withJSONObject: notification)
        
        // URL per l'API di Firebase Cloud Messaging (FCM)
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        
        
        print(jsonData)
        // Crea una richiesta HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        
        // Aggiungi la chiave del server di Firebase alle intestazioni della richiesta
        request.addValue("key=\(key_server)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Invia la richiesta
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Errore nell'invio della notifica push: \(error.localizedDescription)")
                self.error = error.localizedDescription
                showError.wrappedValue = true
                return
            }
                
                print("Here!")
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        print("Notifica push inviata con successo!")
                        sent.wrappedValue = true
                    } else {
                        print("Errore nell'invio della notifica push: \(response.statusCode)")
                        self.error = response.description
                        showError.wrappedValue = true
                    }
                }
                
            }
            task.resume()
        }
    
    
    public func getICloudStatus(){
        CKContainer(identifier: "iCloud.ICLOUD.SNAPP").accountStatus { [weak self] returnedStatus, returnedError in

                switch returnedStatus {
                case .available:
                    self?.isSignedInToiCloud = true
                case .noAccount:
                    self?.error = CloudKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    self?.error = CloudKitError.iCloudAccountNotDetermined.rawValue
                case .restricted:
                    self?.error = CloudKitError.iCloudAccountRestricted.rawValue
                default:
                    self?.error = CloudKitError.iCloudAccountUnkown.rawValue
                }
            }
        
    }
    
    enum CloudKitError: String, LocalizedError{
        case iCloudAccountNotFound
        case iCloudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnkown
    }
    
}
    
//    func numToId(num: String) -> Int64 {
//        return (Int64) num.hashValue
//    }
//}
