//
//  TKConstants.swift
//  Techlytik
//
//  Created by Mati ur Rab on 8/6/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
class TKConstants: NSObject {
    
    //MARK: Webservice constants
//    static let BASE_URL                                     = "https://nodetechlytik.appspot.com/api/"
//    static let BASE_URL                                     = "http://101.50.90.187:5000/"
    
//    static let BASE_URL                                     = "http://124.109.35.207:5000/"
    
    static let BASE_URL                                    = "http://202.165.247.220:5000/"
    
    static let LOGIN                                       = "api/auth/login"
    static let ORGANIZATIONS                               = "cloud/data/organizationList"
    static let SIGNUP                                      = "cloud/authorise/register"
    static let SIGNUP_FACEBOOK                             = "api/auth/socialResponse"
    static let SIGNUP_GOOGLE                               = "callback/google"
    static let TOKEN_VERIFICATION_API                      = "api/auth/accountActivation"
    static let CONFIGURATIONS_API                          = "cloud/data/dynamicGrid"
    static let CONFIGURATIONS_UPDATE                       = "cloud/data/dynamicUpdate"
    static let CONFIGURATIONS_CLONE                        = "cloud/data/loadConfigurations"
    static let CONFIGURATIONS_DATABASE_VALUES              = "cloud/data/selectQuery"
    static let MAPS_CALL                                   = "cloud/data/dynamicQuery"
    static let GET_PROFILE                                 = "cloud/data/profile"
    
    //MARK: User Defaults constants
    static let TK_USER_DAO                                 = "userDAO"
    static let TK_GOOGLE_SIGNED_IN_NOTIFICATION            = "signedInSuccessful"
    static let TK_REMOVE_ANY_LAYER                         = "TK_REMOVE_UNWANTED_LAYERS"
    static let TK_USER_EMAIL                               = "email"
    static let TK_USER_PASSWORD                            = "password"
    static let TK_USER_REMEMBER_ME_OPTION                  = "isRememberMe"

    
    //MAKR: seagues constants
    static let TK_SHOW_MAPVIEW_ON_LOGIN                    = "TK_SHOW_MAP_VIEW"
    static let TK_SHOW_MAPVIEW_ON_REGISTER                 = "showMapViewFromRegister"
    static let TK_SHOW_LOGIN_SCREEN_FROM_SPLASH            = "showLoginScreen"
    
    //MARK: Other constants
    static let TK_BEARER_CONSTANT                          = "Bearer"
    static let TK_TOKEN_CONSTANT                           = "AccessToken"
    static let TK_SELECTED_DEVICE_ID                       = "selectedDeviceId"
 
                   
}

let iPAD                                                   = UIDevice.current.model == "iPad"
let APPDELEGATE                                            = UIApplication.shared.delegate as! AppDelegate
let APPWINDOW                                              = APPDELEGATE.window
