//
//  SecondViewController.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import Alamofire

class SecondViewController: UIViewController {
    
    let network = SimpleClient(baseURL: URL(string: "http://localhost:8181/api/v1")!)
    
    override func viewDidLoad() {
        super.viewDidLoad(); printTypeOf(self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createHevent() {

//        APIClient.creatHevent(
//            id: nil,
//            ownerId: Auth.userid,
//            name: Auth.name,
//            active: true, share: true,
//            duration: 240, created: convertTimeDateToInt(),
//            memberPicture: nil
//        ) { res in
//
//            if res.isSuccess {
//                 print("created Hevent", res)
//            } else {
//                print("error create Hevent", res.error?.localizedDescription as Any)
//            }
//
//        }
        APIClient.creatPerson(id: nil, firstName: "Saroar>", lastName: "<Khandoker", phoneNumbers: []) { result in
            if result.isSuccess {
                 print("created Hevent", result)
            } else {
                print("error create Person", result.error?.localizedDescription as Any)
            }
        }
        
        let params = [
            "id": nil,
            "firstName": "SASSS",
            "lastName": "KHHHAA"
            ] as! [String: String]
        
        network.post(Person.self, endpoint: "/person", params: params, body: Person, headers: Auth.setHeaders()) { decode, response, error in
            print("\(decode) \(response) \(error)")
        }

        
        
    }

    func convertTimeDateToInt() -> Int {
        let now = Date()
        return Int(now.timeIntervalSinceReferenceDate)
    }

    
    @IBAction func createEventTapped(_ sender: Any) {
        createHevent()
    }
}

