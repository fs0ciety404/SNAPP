//
//  PageModel.swift
//  Snapp
//
//  Created by Davide Ragosta on 17/03/23.
//

import Foundation

struct Page: Equatable, Identifiable {
    let id = UUID()
    var name: String
    var descriptio: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title", descriptio: "Description", imageUrl: "", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "WELCOME TO SNAPP", descriptio: "Turn on Notification", imageUrl: "bell.and.waves.left.and.right.fill", tag: 0),
        
        Page(name: "Welcome to SNAPP 2", descriptio: "Start by import your favourite contact on your Apple Watch2", imageUrl: "", tag: 1),
        
        Page(name: "Welcome to SNAPP 3", descriptio: "Start by import your favourite contact on your Apple Watch3", imageUrl: "", tag: 2)
    ]
}
