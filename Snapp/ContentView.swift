//
//  ContentView.swift
//  Snapp
//
//  Created by Francesco De Stasio on 10/03/23.
//
import SwiftUI
import CoreHaptics

struct ContentView: View {
    @ObservedObject var viewModel = SessionDelegator()
    @State var connected = !UserDefaults.standard.bool(forKey: "connectedNumber")
   
    @State private var text = ""
    var chatController = ChatController()
    
    
    var body: some View {
        ContactsView(viewModel: viewModel)
            .alert("", isPresented: $connected, actions: {
                       TextField(".number", text: $text)
                    .keyboardType(.numberPad)
                      
                       Button("Save", action: {
                           UserDefaults.standard.set(true, forKey: "connectedNumber")
                           var user = User(token: DeviceTokenManager.shared.deviceToken!, number: text)
                           chatController.saveUser(user: user)
                       })
                   }, message: {
                       Text(".enter_your_number")
                   })
            
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
