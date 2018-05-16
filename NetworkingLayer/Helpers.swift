//
//  Helpers.swift
//  NetworkingLayer
//
//  Created by Alif on 16/05/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

extension Encodable {
    var jsonData: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Decodable {
    static func from(json: String, using encoding: String.Encoding = .utf8) -> Self? {
        guard let data = json.data(using: encoding) else { return nil }
        return Self.from(data: data)
    }
    
    static func from(data: Data) -> Self? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Self.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
}
