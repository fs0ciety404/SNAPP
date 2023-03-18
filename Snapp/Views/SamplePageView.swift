//
//  WelcomePageView.swift
//  Snapp
//
//  Created by Davide Ragosta on 17/03/23.
//

import SwiftUI

struct SamplePageView: View {
    
    var page: Page
    
    var body: some View {
        VStack{
            Text(page.name)
                .padding()
            Image(systemName: page.imageUrl)
                .scaledToFit()
                .padding()
            Text(page.descriptio)
                .padding()
        }
    }
}

struct SamplePageView_Previews: PreviewProvider {
    static var previews: some View {
        SamplePageView(page: Page.samplePage)
    }
}
