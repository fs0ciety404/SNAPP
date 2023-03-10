//
//  HapticSenderView.swift
//  MC3WatchOS
//
//  Created by Davide Ragosta on 23/02/23.
//

import SwiftUI

import CoreHaptics

struct HapticSenderView: View {
    
    let engine = HapticManager()
    
    var body: some View {
        VStack{
            AnimationViewModel()
        }
        .onAppear(perform: engine?.prepareHaptics)
        .onTapGesture{
            engine?.playSlice()
        }
    }
}

struct HapticSenderView_Previews: PreviewProvider {
    static var previews: some View {
        HapticSenderView()
    }
}
