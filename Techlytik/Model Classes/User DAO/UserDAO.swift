//
//  UserDAO.swift
//  Techlytik
//
//  Created by mac new on 8/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import UIKit

class UserDAO: NSObject, NSCoding {
    
    var id:Int = 0
    var username:NSString = ""
    var img:NSString = ""
    var token:NSString = ""
    var org:NSString = ""
    
    
    init(token: String, id: Int,username: String,img: String, org:String)
    {
        self.token = token as NSString
        self.id = id
        self.username = username as NSString
        self.img = img as NSString
        self.org = org as NSString
    }

    required init(coder decoder: NSCoder) {
        
        self.token = decoder.decodeObject(forKey: "token") as! NSString
        self.id = Int(decoder.decodeInt32(forKey: "id"))
        self.username = decoder.decodeObject(forKey: "username") as! NSString
        self.img = decoder.decodeObject(forKey: "img") as! NSString
        self.org = decoder.decodeObject(forKey: "org") as! NSString
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(token, forKey: "token")
        coder.encode(id, forKey: "id")
        coder.encode(username, forKey: "username")
        coder.encode(img, forKey: "img")
        coder.encode(org, forKey: "org")
    }
}
