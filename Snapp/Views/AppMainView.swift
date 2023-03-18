//
//  AppMainView.swift
//  Snapp
//
//  Created by Davide Ragosta on 17/03/23.
//

import SwiftUI

struct AppMainView: View {
    
    @ObservedObject var viewModel = SessionDelegator()
    @State var connected = !UserDefaults.standard.bool(forKey: "connectedNumber")
    @State var result = false
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
                    chatController.saveUser(user: user, result: $result)
                })
            }, message: {
                Text(".enter_your_number")
            })
            .alert("", isPresented: $result, actions: {
                Button("Ok") {}
            }, message: {
                Text(chatController.cloudResult)
                    .bold()
            })
    }
}

struct AppMainView_Previews: PreviewProvider {
    static var previews: some View {
        AppMainView()
    }
}
