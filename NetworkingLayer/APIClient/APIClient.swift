//
//  APIClient.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation
import Alamofire

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
    
    static func login(username: String, password: String, completion:@escaping (Result<User>)->Void) {
        
        performRequest(
            route: APIRouter.login(username: username, password: password),
            completion: completion
        )
    }
    
    static func getHangoutChannelss(completion:@escaping (Result<[HangoutChannels]>)->Void) {
        
//        let jsonDecoder = JSONDecoder()
//        jsonDecoder.dateDecodingStrategy = .formatted(.eventDateFormatter)
        
        getRequest(
            route: APIRouter.events,
            headers: Auth.setHeaders(),
            completion: completion
        )
    }
    
    func getAllActiveHangouts(successBlock: @escaping ([HangoutChannels]) -> Void) {
        
        let apiMethod = "\(Auth.host)/api/v1/active_hangout_channels"
        
        Alamofire.request(apiMethod, method: .get, headers: Auth.setHeaders()).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                
                guard let data = response.data else { return }
                
                do {
                    let result = try JSONDecoder().decode([HangoutChannels].self, from: data)
                    successBlock(result)
                } catch {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
