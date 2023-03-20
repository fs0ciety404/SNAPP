//
//  ContactCardWatch.swift
//  MC3WatchOS Watch App
//
//  Created by Francesco De Stasio on 16/02/23.
//

import SwiftUI

struct ContactCardWatch: View {
    
    var contact : MyContact
    @Binding var contacts : [MyContact]
    @State var deleteContact = false
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: MyCardView(contact: contact, contacts: $contacts)) {
                ZStack{
                    Image("CardBG")
                        .scaleEffect(3.0)
                        .opacity(0.7)
                    HStack{
                        VStack(alignment: .leading){
                            
                            Text(contact.name ?? "")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(Color("Text"))
                            
                            Text(contact.surname ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .frame()
            }
            .navigationTitle(".favourites")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContactCardWatch_Previews: PreviewProvider {
    static var previews: some View {
        ContactCardWatch(contact: MyContact(), contacts: .constant([]))
    }
}
