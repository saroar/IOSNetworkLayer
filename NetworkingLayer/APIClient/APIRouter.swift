//
//  APIRouter.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(username:String, password:String)
    case events
    case event(id: Int)
    case createHevent(
        ownerId: String,
        name: String,
        memberPictureUrls: MemberPictureUrls?,
        active: Bool,
        share: Bool,
        duration: Int,
        created: Int
    )
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .events, .event:
            return .get
        case .createHevent:
            return .post
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/login"
        case .events:
            return "/active_hangout_channels"
        case .event(let id):
            return "/event/\(id)"
        case .createHevent:
            return "/hangout_channel"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return [K.APIParameterKey.username: username, K.APIParameterKey.password: password]
        case .events, .event:
            return nil
        case .createHevent(
                           let ownerId,
                           let name,
                           let memberPictureUrls,
                           let duration,
                           let share,
                           let active,
                           let created
                           ):
            
            return [
                K.HeventAPIParameterKey.ownerID: ownerId,
                K.HeventAPIParameterKey.name: name,
                K.HeventAPIParameterKey.memberPictureUrls: memberPictureUrls ?? String.empty,
                K.HeventAPIParameterKey.duration: duration,
                K.HeventAPIParameterKey.share: share,
                K.HeventAPIParameterKey.active: active,
                K.HeventAPIParameterKey.created: created
            ]
            
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
