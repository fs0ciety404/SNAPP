//
//  SplashscreenViewWatchOS.swift
//  SnappWatch Watch App
//
//  Created by Davide Ragosta on 17/03/23.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct SplashscreenViewWatchOS: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var animationFinished: Bool = false
    
    @State var animationStarted: Bool = false
    
    @State var removeGif: Bool = false
    
    @State var contactsJSON = itemsJSON
    
    var body: some View {
        ZStack{
            
            NavigationStack{
                ContactsViewWatch(contactsJSON: $contactsJSON, viewModel: SessionDelegator())
                    .navigationTitle(".favourites")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
            ZStack{
                
                Color("BG")
                    .ignoresSafeArea()
                
                if !removeGif{
                    
                    ZStack{
                        
                        if animationStarted {
                            
                            if animationFinished {
                                
                                if colorScheme == .light {
                                    Image("LOGO")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.64)
                                    
                                } else {
                                    Image("LOGO")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.64)
                                }
                            } else {
                                
                                if colorScheme == .light {
                                    
                                    WebImage(url: URL(string: "https://github.com/fs0ciety404/SNAPP/blob/main/Shared/SPLASHSCREEN-INVERSA.gif?raw=true"))
                                        .resizable()
                                        .scaledToFit()
                                    
                                } else {
                                    WebImage(url: URL(string: "https://github.com/fs0ciety404/SNAPP/blob/main/Shared/SPLASHSCREEN.gif?raw=true"))
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                    .animation(.none, value: animationFinished)
                }
            }
            .opacity(animationFinished ? 0 : 1)
        }
        .onAppear{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                
                animationStarted = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    withAnimation(.easeInOut(duration: 0.7)){
                        animationFinished = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        removeGif = true
                    }
                }
                
            }
        }
    }
}

struct SplashscreenViewWatchOS_Previews: PreviewProvider {
    static var previews: some View {
        SplashscreenViewWatchOS()
    }
}
