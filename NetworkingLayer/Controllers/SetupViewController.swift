//
//  SetupViewController.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import Alamofire

func printLine(symbol: String? = nil, isTop: Bool = true) {
    let symbol = symbol ?? (isTop ? "▽" : "△")
    let str = Array<String>(repeating: symbol, count: 30)
    print(str.joined())
}

func printTypeOf(_ t: Any) {
    print("\n【 \(type(of: t)) 】")
}


class SetupViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        activityIndicator.startAnimating()
        
        print("1")
        // Test Login request
//        APIClient.login(username: "saroar", password: "password") { result in
//            switch result {
//            case .success(let user):
//                print("_____________________________")
//                print(user)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        Auth.sessionid = UserDefaults.standard.string(forKey: "sessionid") ?? String.empty
        Auth.csrf      = UserDefaults.standard.string(forKey: "csrf")      ?? String.empty
        
        if Auth.sessionid.isEmpty {
            Alamofire.request("\(Auth.host)/api/v1/session", headers: Auth.setHeaders()).responseJSON { response in
                if response.response?.statusCode != 400 {
                    
                    if let jsonValue = response.result.value {
                        
                        let json = jsonValue as? [String: Any] ?? [String: Any]()
                        
                        Auth.sessionid = json["sessionid"] as? String ?? ""
                        Auth.csrf      = json["csrf"] as? String ?? ""
                        
                        UserDefaults.standard.set(Auth.sessionid, forKey: "sessionid")
                        UserDefaults.standard.set(Auth.csrf, forKey: "csrf")
                    }
                    
                } else {
                    print("SESSION FAIL")
                }
                
                DispatchQueue.main.async { self.go("finishedLoading") }
            }
        } else {
            
            Alamofire.request("\(Auth.host)/api/v1/me", headers: Auth.setHeaders()).responseJSON { response in
                
                if response.response?.statusCode != 400 {
                    if let jsonValue = response.result.value {
                        let json = jsonValue as? [String: Any] ?? [String: Any]()
                        
                        guard let currentuserId = json["userid"] as? String else {
                            print("Cant Find User id")
                            return
                        }
                        
                        Auth.userid       = currentuserId
                        Auth.username     = json["username"] as? String ?? ""
                        Auth.email        = json["email"]    as? String ?? ""
                        Auth.usertype     = json["usertype"] as? String ?? ""
                        Auth.userdetails  = json["details"]  as? [String: Any] ?? [String: Any]()
                        
                    }
                    
                    DispatchQueue.main.async { self.go("loggedIn") }
                    
                } else {
                    
                    print("Failure to retrieve user data (likely not logged in)")
                    Auth.getSession()
                    DispatchQueue.main.async { self.go("finishedLoading") }
                }
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
    }

    func go(_ seque: String) {
        self.performSegue(withIdentifier: seque, sender: nil)
    }
}
