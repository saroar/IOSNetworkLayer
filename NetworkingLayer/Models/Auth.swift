
//
//  Auth.swift
//  NetworkingLayer
//
//  Created by Alif on 06/05/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

// Abstract the POST and GET requests
struct Auth {
    
    //public static var host    = "http://34.252.0.109:80"
    //    public static var host    = "http://10.0.1.3:8181"
//    public static var host      = "http://109.195.84.71:8181"
        public static var host      = "http://localhost:8181"

    
    public static var sessionid      = String.empty
    public static var csrf           = String.empty
    public static var userid         = String.empty
    
    public static var username       = String.empty
    public static var profileImage:  String?
    public static var name           = String.empty
    public static var firstname      = String.empty
    public static var lastname       = String.empty
    public static var gender         = String.empty
    
    public static var email          = String.empty
    public static var usertype       = String.empty
    
    // User preferences
    public static var userdata       = [String: Any]()
    public static var userdetails    = [String: Any]()
    public static var accountType    = "none"
    
    public static var mobilenumber    = String.empty
    public static var cityofresidence = String.empty
    public static var datefobirth     = String.empty
    
    public static var friendsTotalCount: Int?
    
    public static func realname() -> String {
        if !name.isEmpty {
            return name
        } else if !username.isEmpty {
            return username.capitalized
        } else if !userdetails.isEmpty {
            guard
                let firstname = userdetails["firstname"] as? String,
                let lastname = userdetails["lastname"] as? String
                else {
                    return "missing names from FB"
            }
            
            let fullName = "\(firstname) \(lastname)"
            return fullName
        } else {
            return UserDefaults.standard.object(forKey: userid) as? String ?? ""
        }
    }
    
    func age(dateOfBirth: Date) -> Int {
        let now = Date()
        let birthday: Date = dateOfBirth
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = ageComponents.year!
        return age
    }
    
    public static func setHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(sessionid)",
            "X-CSRF-Token": "\(csrf)"
        ]
        return headers
    }
    
    public static func startup() {
        print("running startup")
        
        Auth.sessionid = UserDefaults.standard.string(forKey: "sessionid") ?? String.empty
        Auth.csrf = UserDefaults.standard.string(forKey: "csrf")  ?? String.empty
        
        if Auth.sessionid.isEmpty {
            Auth.getSession()
        } else {
            // Load user data
            print("Load user data")
            Auth.getMe()
        }
    }
    
    /// Load user info
    /// Requires LoacalAuth 1.1.0 or later
    public static func getMe() {
        if !Auth.sessionid.isEmpty {
            Alamofire.request("\(Auth.host)/api/v1/me", headers: Auth.setHeaders()).responseJSON { response in
                if response.response?.statusCode != 400 {
                    if let jsonValue = response.result.value {
                        let json = jsonValue as? [String: Any] ?? [String: Any]()
                        
                        guard let currentuserid = json["userid"] as? String else {
                            print("Cant Find User id")
                            return
                        }
                        
                        Auth.userid     = currentuserid
                        Auth.username   = json["username"] as? String ?? String.empty
                        Auth.email      = json["email"]    as? String ?? String.empty
                        Auth.usertype   = json["usertype"] as? String ?? String.empty
                        
                        UserDefaults.standard.set(name, forKey: userid)
                        UserDefaults.standard.synchronize()
                    }
                } else {
                    print("Failure to retrieve user data (likely not logged in)")
                }
            }
        }
    }
    
    /// Load User Preference Data
    public static func getMyData(_ callback: @escaping () -> Void) {
        if !Auth.sessionid.isEmpty {
            Alamofire.request("\(Auth.host)/api/v1/mydata", headers: Auth.setHeaders()).responseJSON { response in
                if response.response?.statusCode != 400 {
                    if let jsonValue = response.result.value {
                        let json = jsonValue as? [String: Any] ?? [String: Any]()
                        Auth.userdata     = json["userdata"] as? [String: Any] ?? [String: Any]()
                    }
                    callback()
                } else {
                    print("Failure to retrieve user data (likely not logged in)")
                }
            }
        }
    }
    
    /// Save User Preference Data
    public static func saveMyData(_ data: [String: Any], _ callback: @escaping (String, String) -> Void) {
        
        let parameters: Parameters = data
        
        Alamofire.request("\(Auth.host)/api/v1/mydata", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth.setHeaders()).responseJSON { response in
            if response.response?.statusCode != 400 {
                if let jsonValue = response.result.value {
                    let json = jsonValue as? [String: Any] ?? [String: Any]()
                    
                    let msg = json["msg"] as? String ?? String.empty
                    let error = json["error"] as? String ?? String.empty
                    
                    callback(error, msg)
                }
            } else {
                // print("Change Password Fail: \(response.result.value)")
                callback("commerror", "Failed to communicate with Authentication Server")
            }
        }
    }
    
    public static func getSession() {
        Alamofire.request("\(Auth.host)/api/v1/session").responseJSON { response in
            if response.response?.statusCode != 400 {
                if let jsonValue = response.result.value {
                    let json = jsonValue as? [String: Any] ?? [String: Any]()
                    Auth.saveSessionIdentifiers(
                        json["sessionid"] as? String ?? String.empty,
                        json["csrf"] as? String ?? String.empty )
                }
            } else {
                print("SESSION FAIL")
            }
        }
    }
    
    public static func saveSessionIdentifiers(_ sessionid: String, _ csrf: String) {
        Auth.sessionid = sessionid
        Auth.csrf = csrf
        
        UserDefaults.standard.set(sessionid, forKey: "sessionid")
        UserDefaults.standard.set(csrf, forKey: "csrf")
    }
    

    
    public static func register(username: String, email: String, _ callback: @escaping (String) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "email": email
        ]
        Alamofire.request("\(Auth.host)/api/v1/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth.setHeaders()).responseJSON { response in
            if response.response?.statusCode != 400 {
                if let jsonValue = response.result.value {
                    let json = jsonValue as? [String: Any] ?? [String: Any]()
                    
                    let msg = json["error"] as? String ?? String.empty
                    
                    callback(msg)
                }
            } else {
                //                print("Register Fail")
                callback("Registration error: Please make sure you have entered a valid username and email.")
            }
        }
    }
    
    public static func changePassword(_ password1: String, _ password2: String, _ callback: @escaping (String, String) -> Void) {
        
        guard password1 == password1 else {
            callback("pwdmatch", "The passwords do not match")
            return
        }
        
        // Add any other password criteria checking here
        let parameters: Parameters = [ "password": password1 ]
        Alamofire.request("\(Auth.host)/api/v1/changepassword", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth.setHeaders()).responseJSON { response in
            
            guard response.response?.statusCode == 400,
                let jsonValue = response.result.value  else {
                    callback("commerror", "Failed to communicate with Authentication Server")
                    return
            }
            
            let json = jsonValue as? [String: Any] ?? [String: Any]()
            
            _ = json["msg"]   as? String ?? String.empty
            _ = json["error"] as? String ?? String.empty
            
        }
    }
    
    public static func logout(_ callback: @escaping () -> Void) {
        // reset props
        Auth.userid     = String.empty
        Auth.username     = String.empty
        Auth.email         = String.empty
        Auth.usertype     = String.empty
        Auth.userdata     = [String: Any]()
        
        Alamofire.request("\(Auth.host)/api/v1/logout", headers: Auth.setHeaders()).responseJSON { _ in
            Auth.saveSessionIdentifiers(String.empty, String.empty)
            
            // now get new session
            Auth.getSession()
            callback()
        }
        
    }
    
    public static func upgradeUser(_ provider: String, _ token: String, _ callback: @escaping (String) -> Void) {
        
        Alamofire.request("\(Auth.host)/api/v1/oauth/upgrade/\(provider)/\(token)", method: .get, headers: Auth.setHeaders()).responseJSON { response in
            
            if response.response?.statusCode != 400 {
                if let jsonValue = response.result.value {
                    let json = jsonValue as? [String: Any] ?? [String: Any]()
                    
                    let userid = json["userid"] as? String ?? String.empty
                    Auth.firstname = json["firstname"] as? String ?? String.empty
                    Auth.lastname  = json["lastname"]  as? String ?? String.empty
                    Auth.name = "\(Auth.firstname) \(Auth.lastname)"
                    
                    callback(userid)
                }
            } else {
                callback("Failed to communicate with Authentication Server")
            }
        }
    }
    
}
