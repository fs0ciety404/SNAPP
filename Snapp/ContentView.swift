//
//  ContentView.swift
//  Snapp
//
//  Created by Francesco De Stasio on 10/03/23.
//
import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    @State private var showingSheet = false
    @State var pageIndex = 0
    private let pages: [Page] = Page.samplePages
    private let dotApparance = UIPageControl.appearance()
    @AppStorage("firstTimeOnly") var firstTime: Bool = true
    @State var notificationService = NotificationService()
    
    var body: some View {
        if firstTime {
            
            TabView(selection: $pageIndex){
                ForEach(pages) { page in
                    VStack{
                        
                        Spacer()
                        SamplePageView(page: page)
                        Spacer()
                        
                        if page == pages.last{
                            Button("Start") {
                                firstTime.toggle()
                                showingSheet.toggle()
                            }
                            .fullScreenCover(isPresented: $showingSheet) {
                                AppMainView()
                            }
                            .buttonStyle(.bordered)
                        } else if page == pages.first {
                            Button("Next", action: incrementPage)
                                .buttonStyle(.bordered)
                                .onAppear{
                                    notificationService.requestPermission()
                                }
                        } else {
                            Button("Next", action: incrementPage)
                                .buttonStyle(.bordered)
                        }
                        
                        Spacer()
                    }
                    .tag(page.tag)
                }
            }
            .animation(.easeInOut, value: pageIndex)
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .interactive))
            .onAppear{
                dotApparance.currentPageIndicatorTintColor = .black
            }
            
        } else {
            AppMainView()
        }
    }
    func incrementPage() {
        pageIndex += 1
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
