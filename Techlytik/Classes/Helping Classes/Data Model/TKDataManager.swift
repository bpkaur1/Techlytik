//
//  TKDataManager.swift
//  Techlytik
//
//  Created by Mati ur Rab on 8/6/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
//import MBProgressHUD

class TKDataManager: NSObject {
    typealias CompletionHandler = (_ success:Bool, _ jsonDictionary:NSDictionary, _ message:NSString, _ token:NSString) -> Void
    
    let webManager = TKWebServiceManager.sharedInstance
    var myLoader = URActivityIndicator()
    func downloadDataFromUrl(url: NSURL,jsonParameters:NSDictionary, httpMethod:NSString,viewController:UIViewController,completionHandler: @escaping CompletionHandler) {
        
        
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrl(url: url, jsonParameters: jsonParameters, httpMethod: httpMethod) { (data, response) in
                do {
                    
                    let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    print(string1)
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0 {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }else if responseType == 1
                        {
                            let jsonDictionary:NSDictionary = json.object(forKey: "data") as! NSDictionary
                            var message:NSString = ""
                            if let val:NSString = jsonDictionary["message"] as? NSString{
                                message = val
                            }
                            
                            var token:NSString = ""
                            if let val:NSString = jsonDictionary["token"] as? NSString{
                                token = val
                            }else if let val:NSString = json["token"] as? NSString{
                                token = val
                            }
                            
                            completionHandler(true, jsonDictionary, message,token)
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: viewController.view, animated:true)
                
                let alert = UIAlertController(title: "Error!", message: "Internet not available. Please connect to internet and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
            }
        }
    }
    
    func downloadOrganizationsFromUrl(url: NSURL, viewController:UIViewController,completionHandler: @escaping CompletionHandler) {
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrl(url: url) { (data, response) in
                do {
                    let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    print(string1)
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        //                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0 {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }else if responseType == 1 {
                            let jsonArray:NSArray = json.object(forKey: "data") as! NSArray
                            let json:NSDictionary = ["DataArray":jsonArray]
                            completionHandler(true, json, "","")
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: viewController.view, animated:true)
                
                let alert = UIAlertController(title: "Error!", message: "Internet not available. Please connect to internet and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
            }
        }
    }
    
    
    func downloadDataFromUrlWithParemetersInUrl(url: NSURL, viewController:UIViewController,completionHandler: @escaping CompletionHandler) {
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrlWithParemetersInUrl(url: url) { (data, response) in
                do {
                    print("\(data)")
                    let string1 = String(data: data, encoding: String.Encoding.utf8) ?? "Data could not be printed"
                    print(string1)
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0 {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }else if responseType == 1 {
                            let jsonDictionary:NSDictionary = json.object(forKey: "data") as! NSDictionary
                            
                            let token:NSString = json.object(forKey: "token") as! NSString
                            completionHandler(true, jsonDictionary, "",token)
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: viewController.view, animated:true)
                
                let alert = UIAlertController(title: "Error!", message: "Internet not available. Please connect to internet and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
            }
        }
    }
    
    func downloadDataFromUrlWithParemetersInUrlUsingToken(url: NSURL, viewController:UIViewController,token:NSString,completionHandler: @escaping CompletionHandler) {
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrlWithParemetersInUrlUsingToken(url: url, token: token ) { (data, response) in
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0
                        {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }
                        else if responseType == 1
                        {
                            if let jsonDictionary:NSDictionary = json.object(forKey: "data") as? NSDictionary
                            {
                                var message:NSString = ""
                                if let val:NSString = jsonDictionary["message"] as? NSString{
                                    message = val
                                }
                                var token:NSString = ""
                                if let val:NSString = jsonDictionary["token"] as? NSString
                                {
                                    token = val
                                }else if let val:NSString = json["token"] as? NSString{
                                    token = val
                                }
                                completionHandler(true, jsonDictionary, message,token)
                            }
                            else
                            {
                                var token:NSString = ""
                                if let val:NSString = json["token"] as? NSString{
                                    token = val
                                }
                                completionHandler(true, json, "",token)
                            }
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: viewController.view, animated:true)
                
                let alert = UIAlertController(title: "Error!", message: "Internet not available. Please connect to internet and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
            }
        }
    }
    
    func downloadDataFromUrl(url: NSURL,jsonParameters:NSDictionary, token:NSString, httpMethod:NSString,viewController:UIViewController,completionHandler: @escaping CompletionHandler) {
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrl(url: url, jsonParameters: jsonParameters, token: token, httpMethod: httpMethod) { (data, response) in
                do {
                    
                    print("\(data)")
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    {
                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0
                        {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }
                        else if responseType == 1
                        {
                            if let jsonDictionary:NSDictionary = json.object(forKey: "data") as? NSDictionary
                            {
                                var message:NSString = ""
                                if let val:NSString = jsonDictionary["message"] as? NSString{
                                    message = val
                                }
                                var token:NSString = ""
                                if let val:NSString = jsonDictionary["token"] as? NSString
                                {
                                    token = val
                                }else if let val:NSString = json["token"] as? NSString{
                                    token = val
                                }
                                completionHandler(true, jsonDictionary, message,token)
                            }
                            else
                            {
                                var token:NSString = ""
                                if let val:NSString = json["token"] as? NSString{
                                    token = val
                                }
                                completionHandler(true, json, "",token)
                            }
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }else {
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: viewController.view, animated:true)
                
                let alert = UIAlertController(title: "Error!", message: "Internet not available. Please connect to internet and try again", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: TKConstants.TK_REMOVE_ANY_LAYER), object: nil, userInfo: nil)
            }
        }
    }
    
    
    func updateInSilentMode(url: NSURL,jsonParameters:NSDictionary, token:NSString, httpMethod:NSString,viewController:UIViewController,completionHandler: @escaping CompletionHandler) {
        if currentReachabilityStatus != .notReachable {
            webManager.downloadDataFromUrl(url: url, jsonParameters: jsonParameters, token: token, httpMethod: httpMethod) { (data, response) in
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
                        print(json)
                        
                        let responseType:Int = json.object(forKey: "success") as! Int
                        if responseType == 0 {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            completionHandler(false, json, message, "")
                        }else if responseType == 1 {
                            let message:NSString = json.object(forKey: "message") as! NSString
                            
                            if let val:NSString = json["token"] as? NSString{
                                UserDefaults.standard.set(val, forKey: TKConstants.TK_TOKEN_CONSTANT)
                            }
                            
                            completionHandler(true, json, message,token)
                        }
                    }
                } catch let error {
                    let json:NSDictionary = ["":""]
                    completionHandler(false,json, "Server not available, please try later", "")
                    print(error.localizedDescription)
                }
            }
        }
    }
}
