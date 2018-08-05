//
//  SimpleClient.swift
//  NetworkingLayer
//
//  Created by Alif on 17/05/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

enum RestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias HTTPHeaders = [String: String]

struct EmptyRequest: Encodable {}
struct EmptyResponse: Decodable {}

//protocol SimpleClient {
//    var baseURL: URL { get }
//    var session: URLSession { get }
//    func get<D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void)
//    func post<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void)
//    func put<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void)
//    func delete<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void)
//    func performRequest<D: Decodable>(_ responseType: D.Type, request: URLRequest, completion: @escaping (D?, URLResponse?, Error?) -> Void)
//}
//
//class DefaultClient {
//
//}

class SimpleClient {
    let baseURL: URL
    let session: URLSession
    
    init(baseURL: URL) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func get<D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void) {
        let url = baseURL.addEndpoint(endpoint: endpoint).addParams(params: params)
        let request = self.buildRequest(url: url, method: RestMethod.get.rawValue, headers: headers, body: EmptyRequest())
        self.performRequest(responseType, request: request, completion: completion)
    }
    
    func post<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void) {
        let url = baseURL.addEndpoint(endpoint: endpoint).addParams(params: params)
        let request = self.buildRequest(url: url, method: RestMethod.post.rawValue, headers: headers, body: body)
        self.performRequest(responseType, request: request, completion: completion)
    }
    
    func put<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void) {
        let url = baseURL.addEndpoint(endpoint: endpoint).addParams(params: params)
        let request = self.buildRequest(url: url, method: RestMethod.put.rawValue, headers: headers, body: body)
        self.performRequest(responseType, request: request, completion: completion)
    }
    
    func delete<E: Encodable, D: Decodable>(_ responseType: D.Type, endpoint: String, params: [String : String]?, body: E?, headers: HTTPHeaders, completion: @escaping (D?, URLResponse?, Error?) -> Void) {
        let url = baseURL.addEndpoint(endpoint: endpoint).addParams(params: params)
        let request = self.buildRequest(url: url, method: RestMethod.delete.rawValue, headers: headers, body: body)
        self.performRequest(responseType, request: request, completion: completion)
    }
    
    func performRequest<D: Decodable>(_ responseType: D.Type, request: URLRequest, completion: @escaping (D?, URLResponse?, Error?) -> Void) {
        self.session.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                completion(nil, response, error)
            } else {
                guard let responseData = data else {
                    completion(nil, response, error)
                    return
                }
                guard error == nil else {
                    completion(nil, response, error!)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(D.self, from: responseData)
                    completion(result, response, nil)
                } catch {
                    completion(nil, response, error)
                }
            }
            }.resume()
    }
    
    private func buildRequest<E: Encodable>(url: URL, method: String, headers: [String: String]?, body: E?) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        if let requestHeaders = headers {
            for (key, value) in requestHeaders {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let requestBody = body {
            if !(requestBody is EmptyRequest) {
                let encoder = JSONEncoder();
                request.httpBody = try? encoder.encode(requestBody)
            }
        }
        return request
    }
}

fileprivate extension URL {
    func addEndpoint(endpoint: String) -> URL {
        return URL(string: endpoint, relativeTo: self)!
    }
    
    func addParams(params: [String: String]?) -> URL {
        guard let params = params else {
            return self
        }
        var urlComp = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComp.queryItems = queryItems
        return urlComp.url!
    }
}
