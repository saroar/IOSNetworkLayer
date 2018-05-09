//
//  FirstViewController.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad(); printTypeOf(self)
        
        APIClient.getHevents { result in
            switch result {
            case .success(let events):
                print("_____________________________")
                print(events)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedLogOutBtn(_ sender: Any) {
        Auth.logout({
            Auth.sessionid = String.empty
            Auth.csrf = String.empty
            self.performSegue(withIdentifier: "logout", sender: nil)
        })
    }
    
}

