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
    var body: some View {
        MyAnimation()
    }
}

struct MyAnimation : View {
    
    @State private var wawe = false
    
    @State private var wawe1 = false
    
    var body: some View{
        
        ZStack{
            
            Circle()

                .stroke(lineWidth: 2)
                .frame(width: 100,height: 100)
                .foregroundColor(Color.gray.opacity(1))
                .scaleEffect(wawe ? 2 : 1)
                .opacity(wawe ? 0 : 1)
                .shadow(color: .white, radius: 20)
                .brightness(5)
                .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true).speed(0.5))
                .onAppear() {
                    self.wawe.toggle()
                }

            Image("Logo")
                .frame(width: 50, height: 50)
                .scaleEffect(0.45)
                .shadow(radius: 25)
        }
    }
}

struct AnimationViewModel_Previews: PreviewProvider {
    static var previews: some View {
        AnimationViewModel()
    }
}
