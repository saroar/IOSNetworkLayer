//
//  SecondViewController.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad(); printTypeOf(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createHevent() {

//        APIClient.creatHevent(
//            ownerId: Auth.userid,
//            name: Auth.name,
//            memberPictureUrls: nil,
//            active: true,
//            share: true,
//            duration: 240,
//            created: convertTimeDateToInt()
//        ) { res in
//
//            if res.isSuccess {
//                 print("created Hevent", res)
//            } else {
//                print("error create Hevent", res.error?.localizedDescription as Any)
//            }
//
//        }
        APIClient.create(params: <#T##[String : Any]#>, uri: <#T##String#>) { json in
            print(json)
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

