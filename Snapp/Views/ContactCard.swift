//
//  ContactCard.swift
//  MC3WatchOS
//
//  Created by Francesco De Stasio on 16/02/23.
//

import SwiftUI

struct ContactCard: View {
    
    var contact : MyContact
    
    @ObservedObject var viewModel : SessionDelegator
    
    @State var tapped : Bool = false
    @State var isAdded : Bool = false
    @State var showingConfirmation : Bool = false
    @State var showingAlert = false
    @State var notReachable = false
    
    var body: some View {
        
        VStack(alignment: .leading){
            HStack(){
                Text(contact.name ?? "")
                Text(contact.surname ?? "")
            }
            .onTapGesture {
                tapped = !tapped
            }
            if(tapped){
                VStack{
                    ForEach(contact.numbers , id: \.self){ number in
                        Text("\(number)")
                    }
                }
            }
        }
        .swipeActions(edge: .leading) {
            Button{
                showingAlert = true
            }label: {
                Label("sync", systemImage: "star.fill")
            }
            .tint(.green)
        }
        .alert(".save_contact_to_watch", isPresented: $showingAlert) {
            Button ("Save", role: .destructive) {
                if(viewModel.isConnected()){
                    notReachable = false
                    viewModel.sendContacts(contacts: [contact])
                }else{
                    notReachable = true
                }
            }
            
        }
        .alert("Not reachable, open your watch's App", isPresented: $notReachable) {
            Button("Ok", role: .cancel){
                notReachable = false
            }
        }
    }
}

struct ContactCard_Previews: PreviewProvider {
    static var previews: some View {
        ContactCard(contact: MyContact(name: "Aldo", surname: "Califano", numbers: ["343424234"]), viewModel: SessionDelegator()
        )
    }
}
