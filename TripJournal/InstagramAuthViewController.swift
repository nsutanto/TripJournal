//
//  InstagramAuthViewController.swift
//  TripJournal
//
//  Created by Jacqueline Sloves on 4/19/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import UIKit

class InstagramAuthViewController: UIViewController {
    
//  let urlString = "https://api.instagram.com/oauth/authorize/?client_id=60e0fe0b74e849ec83f81f18b781b88f&redirect_uri=https://www.instagram.com/&response_type=code"
    var urlRequest: URLRequest? = nil //this is passed in when view controller is instantiated
    var requestToken: String? = nil
    var accessToken: String! = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    //MARK: - Outlets

    @IBOutlet weak var webView: UIWebView!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("URLREQUEST: ", urlRequest as Any)
        
        webView.delegate = self
        
        navigationItem.title = "Instagram Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(InstagramAuthViewController.cancelAuth))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let urlRequest = urlRequest {
            webView.loadRequest(urlRequest)
        }
    }
    
    //MARK: - Cancel Auth Flow
    
    func cancelAuth() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - InstgramAuthViewController: UIWebViewDelegate

extension InstagramAuthViewController : UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url
        var key: String
        var value: String

        if (url!.query != nil) {
            print("URL.Query", url!.query)
            key = (url!.query?.components(separatedBy: "=").first)!
            value = (url!.query?.components(separatedBy: "=").last)!
            print("Key, value: ", key, value)
            
            if key == "code" {
                let params = [String: AnyObject]()
                let jsonBody = "{\"client_id\": \"\(InstagramClient.Constants.ClientId)\",\"client_secret\":\"\(InstagramClient.Constants.ClientSecret)\", \"grant_type\":\"authorization_code\", \"redirect_uri\":\"\(InstagramClient.Constants.RedirectURI)\", \"code\":\"\(value)\"}"
                print(jsonBody)
                //let params: [String: AnyObject] = [ "client_id" : InstagramClient.Constants.ClientId, "client_secret" : InstagramClient.Constants.ClientSecret, "grant_type" : "authorization_code", "redirect_uri" : InstagramClient.Constants.RedirectURI, "code" : value]
                
                var codeValue = value
                print(codeValue)
                
                InstagramClient.sharedInstance().taskForPostMethod(InstagramClient.Methods.AccessToken, parameters: params, jsonBody: jsonBody) { (results, error) in
                    print(error?.localizedDescription)
                    print("RESULTS", results)
                }

                
            } else if key == "access_token" {
                accessToken = value
                print("ACCESS TOKEN: ", accessToken)
            }
            
            

            
        } else if (url!.fragment != nil) {
            key = (url?.fragment?.components(separatedBy: "=").first)!
            value = (url?.fragment?.components(separatedBy: "=").last)!
            print("Key, value: ", key, value)
            if key == "access_token" {
                accessToken = value 
                print("ACCESS TOKEN: ", accessToken)
            }

        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let urlString = ("https://www.instagram.com#access_token=\(accessToken)")
        print("Redirect URL String + Access Token: ", urlString)
        print("webView.request!.URL!.absoluteString: ", webView.request!.url!.absoluteString)
        if webView.request!.url!.absoluteString == InstagramClient.Constants.RedirectURI {
            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        } else if webView.request!.url!.absoluteString == "" {
            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        }
    }
    
}
