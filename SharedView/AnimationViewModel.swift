//
//  AnimationView.swift
//  MC3WatchOS
//
//  Created by Davide Ragosta on 23/02/23.
//

import SwiftUI
#if os(iOS)
import CoreHaptics
#endif
struct AnimationViewModel: View {
    
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        MyAnimation()
    }
}

struct MyAnimation : View {
    
    @State private var wawe = false
    
    @State private var wawe1 = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        
        ZStack{
            
            if colorScheme == .light {
                
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 100,height: 100)
                    .foregroundColor(Color.gray.opacity(1))
                    .scaleEffect(wawe ? 2 : 0.1)
                    .opacity(wawe ? 0 : 1)
                    .shadow(color: .white, radius: 20)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.5).repeatCount(1))
                    .onAppear() {
                        self.wawe.toggle()
                    }
                
            } else {
                
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 100,height: 100)
                    .foregroundColor(Color.gray.opacity(1))
                    .scaleEffect(wawe ? 2 : 0.1)
                    .opacity(wawe ? 0 : 1)
                    .shadow(color: .white, radius: 20)
                    .brightness(5)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.5).repeatCount(1))
                    .onAppear() {
                        self.wawe.toggle()
                    }
                
            }
            
            Image("LOGO")
                .frame(width: 50, height: 50)
                .shadow(radius: 25)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: false).speed(0.5).repeatCount(1))
        }
    }
}

struct AnimationViewModel_Previews: PreviewProvider {
    static var previews: some View {
        AnimationViewModel()
    }
}
