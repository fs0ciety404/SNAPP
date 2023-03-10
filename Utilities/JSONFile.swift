//
//  JSONFile.swift
//  MC3
//
//  Created by Francesco De Stasio on 20/02/23.
//


import Foundation

var itemsJSON: [MyContact] = loadPack("my_contacts")

func loadPack<T: Decodable>(_ filename: String) -> T {
    let data : Data
    do{
        let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil, create: true).appendingPathComponent(filename)
        data = try Data(contentsOf: file)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        savePack(filename,[])
        return loadPack(filename)
    }
}

func savePack (_ filename: String, _ pack: [MyContact]) -> Void {
    let data: Data
    do {
        let file = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask,appropriateFor: nil, create: true).appendingPathComponent(filename)
        let encoder = JSONEncoder()
        data = try encoder.encode(pack)
        try data.write(to: file)
    } catch {
        fatalError("Couldn't save \(filename) from main bundle:\n\(error)")
    }
}
