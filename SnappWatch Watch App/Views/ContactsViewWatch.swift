//
//  ContactsViewWatch.swift
//  MC3WatchOS Watch App
//
//  Created by Francesco De Stasio on 16/02/23.
//

import SwiftUI

struct ContactsViewWatch: View {
    
    @State private var mainActive = false

    
    @Binding var contactsJSON : [MyContact]
    @ObservedObject var viewModel : SessionDelegator
    @State var contacts : [MyContact] = []
    @State var editContact = false
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        VStack{
            
            if (!viewModel.receivedObjects.isEmpty) {
                List{
                    ForEach(contacts) { contact in
                        ContactCardWatch( contact: contact, contacts: $contacts)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.receivedObjects.removeAll { delCont in
                                        return delCont == contact
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                    }
                }.listStyle(.plain)
                
            }else{
                Text(".error_Send_Contact_From_iPhone")
                    .multilineTextAlignment(.center)
            }
            
        }

        
        .onAppear{
            viewModel.connect()
            if(contacts.isEmpty){
                viewModel.receivedObjects = contactsJSON
                
            }
            contacts = viewModel.receivedObjects
            
        }
        .onChange(of: viewModel.receivedObjects, perform: { newValue in
            self.contacts = viewModel.receivedObjects
            savePack("my_contacts", self.contacts)
        })
        
        
    }
}

struct ContactsViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        ContactsViewWatch(contactsJSON: .constant([]), viewModel: SessionDelegator())
    }
}
