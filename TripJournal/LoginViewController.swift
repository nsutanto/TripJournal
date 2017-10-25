//
//  LoginViewController.swift
//  TripJournal
//
//  Created by Jacqueline Sloves on 4/19/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var myWebView: UIWebView!
    
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        authenticateWithInstagram(usernameTextField.text, password: passwordTextField.text)
        
    }
    
    //MARK: View LifeCycle
    
    override func viewDidLoad(){
        myWebView.isHidden = true
       // InstagramAuthentication()
    }
    
    func InstagramAuthentication(){
        let urlString = "https://api.instagram.com/oauth/authorize/?client_id=60e0fe0b74e849ec83f81f18b781b88f&redirect_uri=https://www.instagram.com/&response_type=code"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        
        myWebView.isHidden = false
        myWebView.loadRequest(request)
    }
    
    func authenticateWithInstagram(_ username: String!, password: String!){
        
        
        InstagramClient.sharedInstance().authenticateWithViewController(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    //TODO: instantiate next View Controller
                    print("SUCCESS")
                } else {
                    print("ERROR!!!!")
                }
            }
            
        }
                let session = URLSession.shared
                //TODO: make function: InstagramURLFromParameters
                let urlString = "https://api.instagram.com/oauth/authorize/?client_id=60e0fe0b74e849ec83f81f18b781b88f&redirect_uri=https://www.instagram.com/&response_type=code"
                let url = URL(string: urlString)
                let request = URLRequest(url: url!)
        
                let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                    print("DATA: ", data)
                    print("RESPONSE: ", response)
                    print("ERROR: ", error)
                    if error == nil {
                        let parsedResult: AnyObject!
                        do {
                            parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
                            print("PARSED RESULT: ", parsedResult)
                        } catch {
                            print("Could not parse data as JSON")
                            return
                        }
                        //self.requestAccessToken()
                    } else {
                        //TODO: Display error message to user
                    }
                }) 
        
                task.resume()
    }
    
    func requestAccessToken(){
        let session = URLSession.shared
        let request = URL(string: "")
        
    }
}
