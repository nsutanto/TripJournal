//
//  InstagramClient.swift
//  TripJournal
//
//  Created by Jacqueline Sloves on 4/19/16.
//  Copyright © 2016 Jacqueline Sloves. All rights reserved.
//

import Foundation

//MARK: - InstagramClient : NSObject 

class InstagramClient : NSObject {

    var session = URLSession.shared
    
    var code: String? = nil
    
    //MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> InstagramClient {
        struct Singleton {
            static var sharedInstance = InstagramClient()
        }
        return Singleton.sharedInstance
    }
    
    //MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String: AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var parameters = parameters
    
        //Set Parameters
        parameters[ParameterKeys.clientId] = Constants.ClientId as AnyObject
        parameters[ParameterKeys.redirectURI] = Constants.RedirectURI as AnyObject
        parameters[ParameterKeys.responseType] = ParameterValues.code as AnyObject
        
        var url = instagramURLFromParameters(parameters, withPathExtension: method)
        print("Line 42, REQUEST URL: ", url)
        
        //Build URL, Configure request
        let request = NSMutableURLRequest(url: url)
        
        //Make the Request
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(result: nil, error: NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }) 
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    
    //MARK: POST
    
    func taskForPostMethod(_ method: String, parameters: [String: AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        var parameters = parameters
        //Set Parameters
        //Build URL, Configure Request
        //var url = instagramURLFromParameters(parameters, withPathExtension: method)
        var urlString = "https://api.instagram.com/oauth/access_token"
        print("Line 90 REQUEST URL: ", urlString)
        var url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print("Line 95 REQUEST: ", request)
        //Make Request
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
        
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(result: nil, error: NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let statusCodeResponse = (response as? HTTPURLResponse)?.statusCode
                print("STATUS CODE: ", statusCodeResponse)
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
        }) 
        
        /* 7. Start the request */
        task.resume()
        
        return task
    
    }
    
    
    //MARK: Helpers
    
    //given RAW JSON, return a usable Foundation object
    fileprivate func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //create a URL from parameters
    fileprivate func instagramURLFromParameters(_ parameters: [String: AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = InstagramClient.Constants.ApiScheme
        components.host = InstagramClient.Constants.ApiHost
        components.path = InstagramClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()

        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
}
