//
//  ContactsView.swift
//  MC3WatchOS
//
//  Created by Francesco De Stasio on 15/02/23.
//

import SwiftUI
import Contacts

struct ContactsView: View {
    
    
    
    @ObservedObject var viewModel : SessionDelegator
    //Edit contacts
    @State var showingAlert = false
    @State var isEditing : Bool = false
    @State var index : Int = 0
    @State var added: Bool = false
    
    @State var resultMsg : LocalizedStringKey = ""
    @State var result : Bool = true
    @State var contacts : [MyContact] = []
    @State private var searchText = ""
    
    var searchResults: [MyContact] {
        if searchText.isEmpty {
            return []
        } else {
            
            let ret = contacts.filter {
                let fullname = ($0.name ?? "") + " " + ($0.surname ?? "")
                return fullname.localizedCaseInsensitiveContains(searchText)
            }
            return ret
        }
    }
    
    
    var body: some View {
        NavigationStack{
            VStack{
                Text(resultMsg)
                    .bold()
                    .onAppear {
                        Task.init{
                            do {
                                if(contacts.isEmpty){
                                    try await fetchAllContacts()
                                    result = true
                                }
                            }
                            catch {
                                resultMsg = ".acceptPrivacyContacts"
                                result = false
                            }
                        }
                    }
                
                List{
                    if(searchText.isEmpty){
                        
                        ForEach(0..<$contacts.count, id: \.self){ contactInd in
                            ContactCard(contact: contacts[contactInd], viewModel: viewModel)
                        }
                        .onChange(of: contacts, perform: { newValue in
                            contacts.sort{
                                $0.name ?? "" < $1.name ?? ""
                            }
                        })
                    }else{
                        
                        ForEach(searchResults,id: \.self){ result in
                            ContactCard(contact: result, viewModel: viewModel)
                            
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationTitle(".contacts")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .searchable(text: $searchText)
        
    }
    
    
    func fetchAllContacts()async throws {
        //get Contacts
        let store = CNContactStore();
        
        //get keys
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys)
        
        DispatchQueue.global(qos: .background).async{
            do {
                try store.enumerateContacts(with: fetchRequest, usingBlock: { contact, result in
                    
                    let person = MyContact()
                    person.setName(name: contact.givenName)
                    person.setSurname(surname: contact.familyName)
                    
                    
                    
                    for number in contact.phoneNumbers {
                        
                        let n = number.value.stringValue
                        var formattedPhoneNumber = n.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                                                   
                        if(formattedPhoneNumber.hasPrefix("39")){
                            formattedPhoneNumber = String(formattedPhoneNumber.dropFirst(2))
                        }
                        person.addNumber(number: formattedPhoneNumber)
                    }
                    DispatchQueue.main.async {
                        contacts.append(person)
                    }
                })
            }
            catch {
                print(".error")
            }
        }
        
    }
    
}




struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(viewModel:  SessionDelegator())
    }
}
