//
//  TKWebServiceManager.swift
//  Techlytik
//
//  Created by Mati ur Rab on 8/6/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation

class TKWebServiceManager:NSObject{
    typealias CompletionHandler = (_ data:Data, _ response:URLResponse?) -> Void
    
    static let sharedInstance = TKWebServiceManager()
    
    func downloadDataFromUrl(url: NSURL,jsonParameters:NSDictionary, httpMethod:NSString,completionHandler: @escaping CompletionHandler) {

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = httpMethod as String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonParameters, options: .prettyPrinted)
            print("request.httpBody: \(String(describing: request.httpBody))")
        } catch let error {
            print("error in post body parameters=\(error.localizedDescription)")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
//                completionHandler(data!, response!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
                return
            }
            completionHandler(data!, response!)
        })
        
        task.resume()
    }
    
    func downloadDataFromUrl(url: NSURL,completionHandler: @escaping CompletionHandler) {
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
//                let data1:NSData = NSData()
//                completionHandler(data1 as Data, response!)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
                return
            }
            completionHandler(data!, response!)
        })
        
        task.resume()
    }
    
    func downloadDataFromUrlWithParemetersInUrl(url: NSURL,completionHandler: @escaping CompletionHandler) {
        
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
//                completionHandler(data!, nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
                return
            }
            completionHandler(data!, response!)
        })
        
        task.resume()
    }
    
    func downloadDataFromUrlWithParemetersInUrlUsingToken(url: NSURL, token:NSString, completionHandler: @escaping CompletionHandler) {
        
        let authValue = String(format: "%@ %@", TKConstants.TK_BEARER_CONSTANT, token)
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let _ = data, error == nil else {
                print("error=\(String(describing: error))")
                //                completionHandler(data!, nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
                return
            }
            completionHandler(data!, response!)
        })
        
        task.resume()
    }
    
    func downloadDataFromUrl(url: NSURL,jsonParameters:NSDictionary, token:NSString, httpMethod:NSString,completionHandler: @escaping CompletionHandler)
    {
        
        let authValue = String(format: "%@ %@", TKConstants.TK_BEARER_CONSTANT, token)

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = httpMethod as String
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(authValue, forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonParameters, options: .prettyPrinted)
            print("request.httpBody: \(String(describing: request.httpBody))")
        } catch let error {
            print("error in post body parameters=\(error.localizedDescription)")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard let _ = data, error == nil else {
                
                print("error=\(String(describing: error))")
                //                completionHandler(data!, response!)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
                return
            }
            completionHandler(data!, response!)
        })
        
        task.resume()
    }
    
}
