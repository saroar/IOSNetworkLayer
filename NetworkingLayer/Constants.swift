//
//  Constants.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://localhost:8181/api/v1/"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let username = "username"
    }
    
    struct HeventAPIParameterKey {
        static let id                = "id"
        static let ownerID           = "ownerID"
        static let name              = "name"
        static let duration          = "duration"
        static let share             = "share"
        static let active            = "active"
        static let created           = "created"
        static let memberPicture     = "memberPicture"
    }
    
    struct PersonAPIParameterKey {
        static let id = "id"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let phoneNumbers = "phoneNumbers"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}


enum ContentType: String {
    case json = "application/json"
}

