//
//  MyCardView.swift
//  Watch
//
//  Created by Davide Ragosta on 02/03/23.
//

import SwiftUI

struct MyCardView: View {
    
    var contact : MyContact
    @Binding var contacts : [MyContact]
    @State var selection: Int? = nil
    
    var body: some View {
        
        NavigationStack{
            
            VStack{
                
                HStack{
                    
                    Text(contact.name ?? "")
                        .font(.title3)
                    Spacer()
                }
                
                HStack{
                    
                    Text(contact.surname ?? "")
                        .font(.title3)
                    Spacer()
                }
            }
            .padding()
            
            HStack{
                Rectangle()
                    .foregroundColor(Color("OurYellow"))
                    .frame(width: 180,height: 2)
            }
            .padding()
            HStack{
                HStack{
                    NavigationLink {
                        SessionWatchView(contact: contact)
                    } label: {
                        Image(systemName: "touchid")
                    }
                }
            }
            .padding()
        }
    }
}



struct MyCardView_Previews: PreviewProvider {
    static var previews: some View {
        MyCardView(contact: MyContact(name:"Aldo", surname: "Califano", numbers: ["3774106116"]), contacts: .constant([]))
    }
}
