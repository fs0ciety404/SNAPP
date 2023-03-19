//
//  SplashscreenViewWatchOS.swift
//  SnappWatch Watch App
//
//  Created by Davide Ragosta on 17/03/23.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI

struct SplashscreenViewWatchOS: View {
    
//    private let images = (0...7).map { UIImage(named: "Image-\($0).jpg")! }
//    private var timer = LoadingTimer()
    
    var body: some View {
        ZStack{
            VStack{
            }
        }
    }
    
//    class LoadingTimer {
//
//        let publisher = Timer.publish(every: 0.1, on: .main, in: .default)
//        private var timerCancellable: Cancellable?
//
//        func start() {
//            self.timerCancellable = publisher.connect()
//        }
//
//        func cancel() {
//            self.timerCancellable?.cancel()
//        }
//    }
}

struct SplashscreenViewWatchOS_Previews: PreviewProvider {
    static var previews: some View {
        SplashscreenViewWatchOS()
    }
}
