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
    
    //    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        HStack{
            if (!viewModel.receivedObjects.isEmpty) {
                VStack{
                ScrollView(.vertical ,showsIndicators: false) {
                        ForEach(contacts) { contact in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
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
                                    .scaleEffect(.init (width: scale, height: scale))
                                    .animation(.easeOut(duration: 1))
                                    .padding(.vertical)
                            }
                            .frame(width: 200 , height: 90)
                            
                        }
                    }
                }
            } else {
                
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
    
    func getScale(proxy: GeometryProxy) -> CGFloat {
                
        let midPint: CGFloat = 200
        
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1
        let deltaXAnimationThreshhold: CGFloat = 200
        
        let diffFromCenter = abs(midPint - viewFrame.origin.x / 2)
        if diffFromCenter < deltaXAnimationThreshhold {
            scale = 1 + (deltaXAnimationThreshhold - diffFromCenter) / 500
        }
        
        return scale
    }
    
}

struct ContactsViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        ContactsViewWatch(contactsJSON: .constant([MyContact(name: "Alfredo", surname: "Alfredo", numbers: ["3332221110"])]), viewModel: SessionDelegator())
    }
}
