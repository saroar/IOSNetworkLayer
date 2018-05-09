//
//  LoginViewController.swift
//  NetworkingLayer
//
//  Created by Alif on 26/04/2018.
//  Copyright © 2018 Alif. All rights reserved.
//

import UIKit
import Alamofire
import OAuthSwift
import SafariServices
import SwiftyJSON

let services = Services()
let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let fFileManager: FileManager = Foundation.FileManager.default

class LoginViewController: UIViewController {
    
    // oauth swift object (retain)
    var oauthswift: OAuthSwift?
    var currentParameters = [String: String]()

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad(); printTypeOf(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }


    @IBAction func loginButtonTapped(_ sender: Any) {
        APIClient.login(username: userNameTextField.text ?? "", password: userPasswordTextField.text ?? "", completion: { msg in

            if msg.isSuccess {
                Auth.accountType = "local"
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "welcome", sender: self)
                }
                print("Login Success From perfect login")
            } else {
                self.labelMessage.text = "Please provide a valid username and password"
            }
        })

    }
}
