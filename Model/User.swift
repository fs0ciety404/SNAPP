//
//  User.swift
//  MC3
//
//  Created by Davide Ragosta on 02/03/23.
//

import Foundation


class User{
    
    var token : String
    var number : String
    
    init(token: String, number: String) {
        self.token = token
        self.number = number
    }
    
    public func getToken() -> String{
        return self.token
    }
    
    public func getNumber()->String{
        return self.number
    }
}

