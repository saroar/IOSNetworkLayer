//
//  Hevent.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

struct MemberPicture: Codable {
    let urls: [String]?
}

struct Hevent: Codable {
    let id: String?
    let ownerID: String
    let name: String
    let active: Bool
    let share: Bool
    let duration: Int
    let created: Int
    let memberPicture: MemberPicture?
    
    typealias JSON = [String: Any]
}

extension Hevent {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case memberPicture = "member_picture"
        case id = "id"
        case share = "share"
        case created = "created"
        case ownerID = "owner_id"
        case active = "active"
        case duration = "duration"
    }
}
