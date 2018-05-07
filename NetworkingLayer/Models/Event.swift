//
//  HangoutChannels.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

struct MemberPictureUrls: Codable {
    private(set) var memberPictureUrls: [String]?
}

struct HangoutChannels: Codable {
    private(set) var name: String
    private(set) var memberPictureUrls: MemberPictureUrls?
    private(set) var id: String
    private(set) var share: Bool
    private(set) var created: Int
    private(set) var ownerID: String
    private(set) var active: Bool
    private(set) var duration: Int
    
    typealias JSON = [String: Any]
}

extension HangoutChannels {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case memberPictureUrls = "member_picture_urls"
        case id = "id"
        case share = "share"
        case created = "created"
        case ownerID = "owner_id"
        case active = "active"
        case duration = "duration"
    }
}

extension MemberPictureUrls {
    enum CodingKeys: String, CodingKey {
        case memberPictureUrls = "member_picture_urls"
    }
}
