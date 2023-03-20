//
//  SplashscreenView.swift
//  Snapp
//
//  Created by Davide Ragosta on 16/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SplashscreenViewIOS: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var animationFinished: Bool = false
    
    @State var animationStarted: Bool = false
    
    @State var removeGif: Bool = false
    
    var body: some View {
        ZStack{
            
            ContentView()
            
            ZStack{
                
                Color("BG")
                    .ignoresSafeArea()
                
                if !removeGif{
                    
                    ZStack{
                        
                        if animationStarted {
                            
                            if animationFinished {
                                
                                if colorScheme == .light {
                                    Image("LIGHT/SPLASHSCREEN0050")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.41)
                                } else {
                                    Image("DARK/SPLASHSCREEN0050")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.41)
                                }
                            } else {
                                
                                if colorScheme == .light {
                                    
                                    AnimatedImage(name: "SPLASHSCREEN-INVERSA.gif")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.5)
                                    
                                } else {
                                    AnimatedImage(name: "SPLASHSCREEN.gif")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .scaleEffect(0.5)
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
                    withAnimation(.easeInOut(duration: 0.5)){
                        
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

struct SplashscreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashscreenViewIOS()
    }
}
