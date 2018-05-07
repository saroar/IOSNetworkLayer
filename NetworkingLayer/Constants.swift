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
        static let baseURL = "http://localhost:8181/api/v1"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let username = "username"
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

