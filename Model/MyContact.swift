//
//  Contact.swift
//  MC3WatchOS
//
//  Created by Francesco De Stasio on 16/02/23.
//

import Foundation
import UIKit

public enum Keys: String, CodingKey {
    case name
    case surname
    case numbers
    case profilepic
}


public class MyContact : NSObject, NSSecureCoding, Identifiable, Codable {
    
    public static var supportsSecureCoding: Bool = true
    
    static func == (lhs: MyContact , rhs: MyContact) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    public var id = UUID()
    @Published var name: String?
    @Published var surname: String? = ""
   // @Published var profilepic: Data?
    @Published var numbers : [String] = []
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Keys.self)
        name = try values.decode(String.self, forKey: .name)
        surname = try values.decode(String.self, forKey: .surname)
       // profilepic = try values.decode(Data.self, forKey: .profilepic)
        numbers = try values.decode([String].self, forKey: .numbers)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        //try container.encode(profilepic, forKey: .profilepic)
        try container.encode(numbers, forKey: .numbers)
    }
    
    override init(){ }
    func initWithNameSurname(name: String, surname: String){
        self.name = name
        self.surname = surname
    }
    
    init(name: String,surname: String, numbers: [String]){
        self.name = name
        self.surname = surname
        //self.profilepic = profilepic
        self.numbers = numbers
    }
    func setName(name: String){
        self.name = name
    }
    func setSurname(surname: String){
        self.surname = surname
    }
//    func setProfilePic(profilepic: Data){
//        self.profilepic = profilepic
//    }
    func addNumber(number: String){
        self.numbers.append(number)
    }
    
    public required convenience init?(coder: NSCoder) {
        
        guard let name = coder.decodeObject(forKey: "name") as? String,
              let surname = coder.decodeObject(forKey: "surname") as? String,
              //let profilepic = coder.decodeObject(forKey: "profilepic") as? Data,
              let numbers = coder.decodeArrayOfObjects(ofClasses: [MyContact.self], forKey: "numbers") as? [String]
                
        else {return nil}
        
        self.init(name: name as String, surname: surname as String, numbers: numbers as [String])
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.surname, forKey: "surname")
        //coder.encode(self.profilepic, forKey: "profilepic")
        coder.encode(self.numbers, forKey: "numbers")
    }
    
}
