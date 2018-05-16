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
    
    @discardableResult
    private static func postReq<T:Encodable>(
        route: APIRouter,
        headers: HTTPHeaders,
        ecoder: JSONEncoder = JSONEncoder(),
        completion:@escaping (Result<T>)->Void
        ) -> DataRequest {
        
//        return Alamofire.request(route)
//            .responseJSONDecodable (decoder: ecoder) { (response: DataResponse<T>) in
//                completion(response.result)
//        }

        return Alamofire.request(route).responseData(completionHandler: { req in
            
        })
    }
    
    static func login(username: String, password: String, completion:@escaping (Result<User>)->Void) {

        performRequest(
            route: APIRouter.login(username: username, password: password),
            completion: completion
        )
    }
    
    static func creatHevent(
        id: String?,
        ownerId: String,
        name: String,
        active: Bool,
        share: Bool,
        duration: Int,
        created: Int,
        memberPicture: MemberPicture?, completion:@escaping (Result<[Hevent]>)->Void) {

        postRequest(
            route: APIRouter.createHevent(
                id: id,
                ownerId: ownerId,
                name: name,
                share: share, active: active,
                duration: duration, created: created,
                MemberPicture: memberPicture
            ),
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
    static func creatPerson(
        id: String?,
        firstName: String,
        lastName: String,
        phoneNumbers: [PhoneNumber]?, completion:@escaping (Result<[Person]>)->Void) {
        
        postRequest(
            route: APIRouter.person(
                id: id,
                firstName: firstName,
                lastName: lastName,
                phoneNumbers: phoneNumbers
            ),
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
    static func getHevents(completion:@escaping (Result<[Hevent]>)->Void) {
        
        getRequest(
            route: APIRouter.events,
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
}
