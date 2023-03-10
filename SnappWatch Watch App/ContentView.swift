//
//  ContentView.swift
//  SnappWatch Watch App
//
//  Created by Francesco De Stasio on 10/03/23.
//

import SwiftUI

struct ContentView: View {
    
    
    @State var contactsJSON = itemsJSON
    var body: some View {
        NavigationStack{
            ContactsViewWatch(contactsJSON: $contactsJSON, viewModel: SessionDelegator())
                .navigationTitle(".favourites")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
