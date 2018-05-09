//
//  APIClient.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    @discardableResult
    private static func performRequest<T:Decodable>(
        route: APIRouter,
        decoder: JSONDecoder = JSONDecoder(),
        completion:@escaping (Result<T>)->Void
        ) -> DataRequest {
        
        return Alamofire.request(route)
            .responseJSONDecodable (decoder: decoder){ (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    @discardableResult
    private static func getRequest<T:Decodable>(
        route: APIRouter,
        headers: HTTPHeaders,
        decoder: JSONDecoder = JSONDecoder(),
        completion:@escaping (Result<T>)->Void
        ) -> DataRequest {
        
        return Alamofire.request(route)
            .responseJSONDecodable (decoder: decoder) { (response: DataResponse<T>) in
                completion(response.result)
        }
    }
    
    @discardableResult
    private static func postRequest<T:Decodable>(
        route: APIRouter,
        headers: HTTPHeaders,
        decoder: JSONDecoder = JSONDecoder(),
        completion:@escaping (Result<T>)->Void
        ) -> DataRequest {
        
        return Alamofire.request(route)
            .responseJSONDecodable (decoder: decoder) { (response: DataResponse<T>) in
                completion(response.result)
        }
        
    }
    
    static func login(username: String, password: String, completion:@escaping (Result<User>)->Void) {

        performRequest(
            route: APIRouter.login(username: username, password: password),
            completion: completion
        )
    }
    
    static func creatHevent(
        ownerId: String,
        name: String,
        memberPictureUrls: MemberPictureUrls?,
        active: Bool,
        share: Bool,
        duration: Int,
        created: Int, completion:@escaping (Result<[Hevent]>)->Void) {

        postRequest(
            route: APIRouter.createHevent(
                ownerId: ownerId,
                name: name,
                memberPictureUrls: memberPictureUrls,
                active: active,
                share: share,
                duration: duration,
                created: created
            ),
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
    static func getHevents(completion:@escaping (Result<[Hevent]>)->Void) {
        
//        let jsonDecoder = JSONDecoder()
//        jsonDecoder.dateDecodingStrategy = .formatted(.eventDateFormatter)
        
        getRequest(
            route: APIRouter.events,
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
}
