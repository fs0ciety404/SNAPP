//
//  SessionWatchView.swift
//  MC3WatchOS Watch App
//
//  Created by Francesco De Stasio on 16/02/23.
//

import SwiftUI
import WatchKit

struct SessionWatchView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var contact : MyContact
    @State var showError = false
    @State var sent = false
    @Environment(\.presentationMode) var presentationMode
    var chatController = ChatController()
    var body: some View {
        ZStack{
            AnimationViewModel()
                .scaleEffect(0.7)
        }
        .alert(".message_is_being_sent", isPresented: $sent){
            Button("Ok"){
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert("Error:" + chatController.error,isPresented: $showError, actions: {
            Button ("Ok") {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .onTapGesture {
            if(!sent){
                chatController.getICloudStatus()
                if(chatController.isSignedInToiCloud){
                    chatController.sendNotification(to: contact.numbers.first!, sent: $sent, showError: $showError)
                }else{
                    showError = true
                }
            }
            
        }
        .ignoresSafeArea()
    }
}



extension SessionWatchView{
    class ViewModel : ObservableObject{
        @Published var message = ""
        
        
        func sendMessage(){
            print(message)
            message.removeAll()
        }
    }
}
struct SessionWatchView_Previews: PreviewProvider {
    static var previews: some View {
        SessionWatchView(contact: MyContact(name:"Aldo", surname: "Califano", numbers: ["3434245"]))
    }
}
