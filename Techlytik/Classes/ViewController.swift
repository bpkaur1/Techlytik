//
//  ViewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
//import MBProgressHUD

class ViewController: UIViewController, GIDSignInUIDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
//    @IBOutlet weak var forgotPasswordLbl: UILabel!
    @IBOutlet weak var rememberMeLbl: UILabel!
//    @IBOutlet weak var rememberMeSwitcher: UISwitch!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginWithFacebookBtn: UIButton!
    @IBOutlet weak var loginWithGoogleBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var organizationDropDownTable: UITableView!
    @IBOutlet weak var bgGrayLayer: UIView!
    @IBOutlet weak var organizationTF: UITextField!
    @IBOutlet weak var organizationBtn: UIButton!
    @IBOutlet weak var cancelRegistration: UIButton!
    @IBOutlet weak var cancelRegistrationBtn: UIButton!
    
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var consTopLogo: NSLayoutConstraint!
    var isCheck : Bool!
    
    //Mark: variables/constants
    var organizationArray:NSMutableArray?
    var selectedOrganization:NSString?
    var isOrgDropdownHidden:Bool?
    var socialID:NSString?
    var usernmae:NSString?
    var profile_Picture:NSString?
    var isSocialSignUP:Bool = Bool()
    var isFacebookLogin:Bool = Bool()
    var myLoader = URActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        organizationArray = NSMutableArray.init()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let modelName = UIDevice.current.modelName
        if modelName == "iPhone 5" || modelName == "iPhone 5s" || modelName == "iPhone 5c" || modelName == "iPhone SE" || modelName == "iPhone 4" || modelName == "iPhone 4s" || modelName == "Simulators"
        {
            consTopLogo.constant = 40
            loginWithFacebookBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                           size: 9.5)
            loginWithGoogleBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                         size: 9.5)
        }
        else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"  || modelName == "iPhone 8 Plus" || modelName == "SimulatorS"
        {
            consTopLogo.constant = 100
            
            if modelName != "iPhone X" || modelName == "Simulator"
            {
            loginWithFacebookBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
            size: 13.0)
            loginWithGoogleBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                         size: 13.0)
            }
        }
        
        
        let notificationName = Notification.Name(TKConstants.TK_GOOGLE_SIGNED_IN_NOTIFICATION)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.logingWithGoogle(notification:)), name: notificationName, object: nil)
        
        let notificationNameForIndicators = Notification.Name(TKConstants.TK_REMOVE_ANY_LAYER)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.removeIndicators), name: notificationNameForIndicators, object: nil)
        
        isOrgDropdownHidden = true;
        self.organizationDropDownTable.isHidden = true
        self.isFacebookLogin = false
        
        adjustRememberMeSettings()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        adjustView();
    }
    
    @IBAction func CheckForREmemberMe(_ sender: Any)
    {
        isCheck = UserDefaults.standard.bool(forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION)
        if isCheck == true
        {
            UserDefaults.standard.set(false, forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION)
            isCheck = false
            btnCheck.setBackgroundImage(UIImage(named : "Uncheckbox."), for: UIControlState.normal)
        }
        else
        {
            UserDefaults.standard.set(true, forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION)
            isCheck = true
            btnCheck.setBackgroundImage(UIImage(named : "Checkbox."), for: UIControlState.normal)
        }
    }
    
    func adjustRememberMeSettings()
    {
        
        isCheck = UserDefaults.standard.bool(forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION)
        if isCheck == true
        {
            
            btnCheck.setBackgroundImage(UIImage(named : "Checkbox."), for: UIControlState.normal)
            if let email:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_USER_EMAIL) as? NSString {
                self.emailTF.text = email as String
            }
            
            if let password:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_USER_PASSWORD) as? NSString {
                self.passwordTF.text = password as String
            }
        }
        else
        {
            btnCheck.setBackgroundImage(UIImage(named : "Uncheckbox."), for: UIControlState.normal)
        }
        
//        print(UserDefaults.standard.bool(forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION))
//        self.rememberMeSwitcher.isOn = UserDefaults.standard.bool(forKey: TKConstants.TK_USER_REMEMBER_ME_OPTION)
//        if self.rememberMeSwitcher.isOn {
//            if let email:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_USER_EMAIL) as? NSString {
//                self.emailTF.text = email as String
//            }
//
//            if let password:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_USER_PASSWORD) as? NSString {
//                self.passwordTF.text = password as String
//            }
//
//        }
    }
    
    func adjustView()
    {
//        addCornerRadiusToView(View: self.loginBtn)
//        addCornerRadiusToView(View: self.loginWithFacebookBtn)
//        addCornerRadiusToView(View: self.loginWithGoogleBtn)
//        addCornerRadiusToView(View: self.registerBtn)
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }
    
    @IBAction func loginBtnTpd(_ sender: Any) {
//                self.emailTF.text = "haseeb.khan@gmail.com"
//                self.passwordTF.text = "123456"
//
//                self.emailTF.text = "mati@gmail.com"
//                self.passwordTF.text = "123"
        var showMessage:Bool = false
        let tkTutilies:TKUtilities = TKUtilities()
        var alertMessage:String = ""
        if (self.emailTF.text?.isEmpty)! {
            showMessage = true
            alertMessage = "Please provide email address"
        }else if (self.passwordTF.text?.isEmpty)! {
            showMessage = true
            alertMessage = "Please provide password"
        }else if(!tkTutilies.isValidEmail(testStr: self.emailTF.text!)){
            showMessage = true
            alertMessage = "Please provide a valid email address"
        }
        
        if showMessage {
            let alert = UIAlertController(title: "Error!", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
//            self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_LOGIN, sender: self)
//            return;
             myLoader.showActivityIndicator(uiView: APPWINDOW!)
            
//            MBProgressHUD.showAdded(to: self.view, animated:true)
            
            
            let email:String = self.emailTF.text! as String
            let password:String = self.passwordTF.text! as String
            
            
            let jsonParameters:NSDictionary = ["Keeploggedin":"", "email":email, "password":password]
            
            
            let url = URL(string: TKConstants.BASE_URL + TKConstants.LOGIN)! //change the url
            print(url)
            print(jsonParameters)
            let dataManager = TKDataManager()
            dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
                
                if success {
                    if self.isCheck == true
                    {
                        UserDefaults.standard.set(self.emailTF.text, forKey: TKConstants.TK_USER_EMAIL)
                        UserDefaults.standard.set(self.passwordTF.text, forKey: TKConstants.TK_USER_PASSWORD)
                        UserDefaults.standard.synchronize()
                    }
                    
//                    if(self.rememberMeSwitcher.isOn){
//                        UserDefaults.standard.set(self.emailTF.text, forKey: TKConstants.TK_USER_EMAIL)
//                        UserDefaults.standard.set(self.passwordTF.text, forKey: TKConstants.TK_USER_PASSWORD)
//                        UserDefaults.standard.synchronize()
//                    }
                    if let val:Int64 = jsonDictionary.object(forKey: "errorCode") as? Int64 {
                        if val == 4002{
                            DispatchQueue.main.async {
                                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                                MBProgressHUD.hide(for: self.view, animated:true)
                                self.showVerificationTokenAlert()
                            }
                        }
                    }
                    else
                    {
                        let userInfoDictionary = jsonDictionary.object(forKey: "userinfo") as! NSDictionary
                        
                        let id = userInfoDictionary.object(forKey: "id")
                        let username = userInfoDictionary.object(forKey: "username")
                        let img = userInfoDictionary.object(forKey: "img")
                        let org = userInfoDictionary.object(forKey: "org")
                        
                        let userDAO = UserDAO.init(token: token as String, id: id as! Int, username: username as! String, img: img as! String, org: org as! String)
                        
                        let encodedData = NSKeyedArchiver.archivedData(withRootObject: userDAO)
                        UserDefaults.standard.set(encodedData, forKey: TKConstants.TK_USER_DAO)
                        UserDefaults.standard.set(token, forKey: TKConstants.TK_TOKEN_CONSTANT)
                        UserDefaults.standard.synchronize()
                        
                        
                        DispatchQueue.main.async
                            {
//                            if(self.rememberMeSwitcher.isOn){
//                                UserDefaults.standard.set(self.emailTF.text, forKey: TKConstants.TK_USER_EMAIL)
//                                UserDefaults.standard.set(self.passwordTF.text, forKey: TKConstants.TK_USER_PASSWORD)
//                            }
                                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                            myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                            MBProgressHUD.hide(for: self.view, animated:true)
                            self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_LOGIN, sender: self)
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                        MBProgressHUD.hide(for: self.view, animated:true)
//                        myLoader.hideActivityIndicator(uiView: APPWINDOW!)
                        
                        let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            
        }
        
    }
    
    func showVerificationTokenAlert() {
        let alert = UIAlertController(title: "Verify Token", message: "Please enter your verification token", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Token..."
            
        }
        alert.addAction(UIAlertAction(title: "Verify", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let text:String = (textField?.text)!
            print("Text field: \(textField?.text)")
            if (textField?.text?.isEmpty)!{
                
                let alert1 = UIAlertController(title: "Error!", message: "Please enter your verification token first", preferredStyle: UIAlertControllerStyle.alert)
                alert1.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert1] (_) in
                    self.showVerificationTokenAlert()
                }))
                self.present(alert1, animated: true, completion: nil)
            }else{
                self.verifyToken(text as NSString)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginWithFacebookBtnTpd(_ sender: Any)
    {
        self.bgGrayLayer.isHidden = false

        isFacebookLogin = true
        
        if (organizationArray != nil) && (organizationArray?.count)!>0 {
            let loginManager = LoginManager()
            loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    self.bgGrayLayer.isHidden = true;
                    print(error)
                case .cancelled:
                    self.bgGrayLayer.isHidden = true;
                    print("User cancelled login.")
                case .success(_, _, _):  //first param is granted permissions, second param is declined permissions, third param is accessToken
                    FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                        if (error == nil){
                            let fbDetails = result as! NSDictionary
                            print(fbDetails)
                            let pictureDictionary = fbDetails.object(forKey: "picture") as! NSDictionary
                            let pictureData = pictureDictionary.object(forKey: "data") as! NSDictionary
                            
                            self.socialID = fbDetails.object(forKey: "id") as? NSString
                            self.usernmae = fbDetails.object(forKey: "name") as? NSString
                            self.profile_Picture = pictureData.object(forKey: "url") as? NSString
                            
                            DispatchQueue.main.async
                                {
                                self.isSocialSignUP = true
                                self.organizationBtnTpd(self)
                            }
                        }
                        else
                        {
                            self.bgGrayLayer.isHidden = true;
                            print(error?.localizedDescription ?? "Not found")
                        }
                    })
                }
            }
        }
        else
        {
            loadOrganizations()
        }
    }
    
    @IBAction func loginWithGoogleBtnTpd(_ sender: Any) {
        isFacebookLogin = false
        
        if (organizationArray != nil) && (organizationArray?.count)!>0 {
            GIDSignIn.sharedInstance().signIn()
        }else{
            loadOrganizations()
        }
    }
    
    func logingWithGoogle(notification:NSNotification){
        if let user = notification.userInfo?["user"] as? GIDGoogleUser {
            self.socialID = user.userID as NSString
            self.usernmae = user.profile.name as NSString
            if user.profile.hasImage{
                let imageUrl = user.profile.imageURL(withDimension: 120)
                self.profile_Picture = imageUrl?.absoluteString as NSString?
                print(" image url: ", imageUrl?.absoluteString as Any)
            }
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1,
                               delay: 0.1,
                               options: UIViewAnimationOptions.curveEaseIn,
                               animations: { () -> Void in
                                self.bgGrayLayer.isHidden = false
                }, completion: { (finished) -> Void in
                })
                
                self.isSocialSignUP = true
                self.organizationBtnTpd(self)
            }
        }else{
            self.bgGrayLayer.isHidden = true;
        }
    }
    
    func removeIndicators(){
        DispatchQueue.main.async {
            self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.hide(for: self.view, animated:true)
        }
    }
    
    @IBAction func registerBtnTpd(_ sender: Any) {
    }
    
    //Google Signin Delegate methods
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func organizationBtnTpd(_ sender: Any) {
        
        isOrgDropdownHidden = !isOrgDropdownHidden!
        
        if isOrgDropdownHidden! {
            self.organizationDropDownTable.alpha = 1.0
        }else{
            self.organizationDropDownTable.alpha = 0.0
        }
        
        //        self.organizationBtn.isUserInteractionEnabled = false
        UIView .animate(withDuration:0.1) {
            if(self.isOrgDropdownHidden!){
                self.organizationDropDownTable.alpha = 0.0
            }else{
                self.organizationDropDownTable.alpha = 1.0
            }
            self.organizationDropDownTable.isHidden = self.isOrgDropdownHidden!
            self.organizationBtn.isUserInteractionEnabled = true
        }
    }
    
    
    //MARK: Organization table dropdown delegates
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (organizationArray?.count)!
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOrgani")as! OrganisationListTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
//        let value = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["value"])! as? Int)!
        let name = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["label"])! as? String)!

       
//        cell.lblValue.text = String(value)
        cell.lblName.text = name
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let value = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["value"])! as? Int)!
          let name = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["label"])! as? String)!
//        selectedOrganization = organizationArray?.object(at: indexPath.row) as! NSString?
        self.organizationTF.text = name
        
        isOrgDropdownHidden = true;
        UIView .animate(withDuration:0.1) {
            self.organizationDropDownTable.alpha = 0.0
            self.organizationDropDownTable.isHidden = self.isOrgDropdownHidden!
            self.organizationBtn.isUserInteractionEnabled = true
        }
        
        self.bgGrayLayer.isHidden = true;
        loginUserWithServer(self.socialID!, self.profile_Picture!, self.usernmae!, String(value))
        
    }
    
    func loginUserWithServer(_ socialID:NSString, _ profile_Picture:NSString, _ username:NSString, _ organization:String){
        
        var socialMedia = "Facebook"
        if isFacebookLogin {
            socialMedia = "Facebook"
        }else{
            socialMedia = "google"
        }
        
        let jsonParameters:NSDictionary = ["social_id":socialID, "name":"", "username":username, "email":"", "profile_picture":profile_Picture, "organization":self.organizationTF.text!, "provider":socialMedia]
        
        let urlString = TKConstants.BASE_URL + TKConstants.SIGNUP_FACEBOOK as String
        
        let url = URL(string: urlString)! //change the url
        print("URL: \(url)")
        print("loginUserWithServer: \(urlString)")
        print("loginUserWithServer: \(jsonParameters)")
        let dataManager = TKDataManager()
        myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                if let val:NSString = jsonDictionary["errorCode"] as? NSString {
                    if val.isEqual(to: "4002"){
                        DispatchQueue.main.async {
                            self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
                            let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                                //  self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    
                    let userInfoDictionary = jsonDictionary.object(forKey: "userinfo") as! NSDictionary
                    
                    let id = userInfoDictionary.object(forKey: "id")
                    let username = userInfoDictionary.object(forKey: "username")
                    let img = userInfoDictionary.object(forKey: "img")
                    let org = userInfoDictionary.object(forKey: "org")
                    
                    let userDAO = UserDAO.init(token: token as String, id: id as! Int, username: username as! String, img: img as! String, org: org as! String)
                    
                    let encodedData = NSKeyedArchiver.archivedData(withRootObject: userDAO)
                    UserDefaults.standard.set(encodedData, forKey: TKConstants.TK_USER_DAO)
                    
                    DispatchQueue.main.async {
                        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
                        //                        self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_REGISTER, sender: self)
                        self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_LOGIN, sender: self)
                    }
                }
            }else{
                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
                    let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }

    
    func loadOrganizations(){
        organizationArray = NSMutableArray.init()
        
        myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        let url = URL(string: TKConstants.BASE_URL + TKConstants.ORGANIZATIONS)!
        print(url)
        let dataManager = TKDataManager()
        dataManager.downloadOrganizationsFromUrl(url: url as NSURL, viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: self.view, animated:true)
            }
            if success {
                self.organizationArray = jsonDictionary.object(forKey: "DataArray") as? NSMutableArray
                print(self.organizationArray ?? "")
//                for i in 0 ..< orgTemp.count {
//                    let dictionary:NSDictionary = orgTemp[i] as! NSDictionary
//                    let orgName:NSString = NSString(format: "%d", dictionary.object(forKey: "value") as! Int)
//                    self.organizationArray?.add(orgName)
//                }
                
                DispatchQueue.main.async {
                    self.organizationDropDownTable.reloadData()
                    
//                    if self.isFacebookLogin
//                    {
//                        self.loginNowWithFB()
//                    }
//                    else
//                    {
//                        self.loginNowWithGoogle()
//                    }
                }
            }
            else
            {
                let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func loginNowWithFB()
    {
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self)
        { loginResult in
            switch loginResult {
            case .failed(let error):
                self.bgGrayLayer.isHidden = true;
                print(error)
            case .cancelled:
                self.bgGrayLayer.isHidden = true;
                print("User cancelled login.")
            case .success(_, _, _):  //first param is granted permissions, second param is declined permissions, third param is accessToken
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email,picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        let fbDetails = result as! NSDictionary
                        print(fbDetails)
                        let pictureDictionary = fbDetails.object(forKey: "picture") as! NSDictionary
                        let pictureData = pictureDictionary.object(forKey: "data") as! NSDictionary
                        
                        self.socialID = fbDetails.object(forKey: "id") as? NSString
                        self.usernmae = fbDetails.object(forKey: "name") as? NSString
                        self.profile_Picture = pictureData.object(forKey: "url") as? NSString
                        
                        DispatchQueue.main.async {
                            self.isSocialSignUP = true
                            self.organizationBtnTpd(self)
                        }
                    }else{
                        self.bgGrayLayer.isHidden = true;
                        print(error?.localizedDescription ?? "Not found")
                    }
                })
            }
        }
    }
    
    func loginNowWithGoogle(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func verifyToken(_ text:NSString) {
        
        let jsonParameters:NSDictionary = ["token":text ]
        
        let urlString = TKConstants.BASE_URL + TKConstants.TOKEN_VERIFICATION_API as String
        
        let url = URL(string: urlString)! //change the url
        print("tokenVerification URL: \(urlString)")
        print("tokenVerification Request Parameters: \(jsonParameters)")
        
        let dataManager = TKDataManager()
         myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
//                    self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_LOGIN, sender: self)
                    
                }
            }else{
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    
                    let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func SubmitSelectedOrganisation(_ sender: Any) {
        self.isSocialSignUP = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.bgGrayLayer.alpha = 0.0
        }) { (isFinished) in
            self.bgGrayLayer.isHidden = true
            self.bgGrayLayer.alpha = 1.0
        }
    }
    
    @IBAction func cancelRegistrationBtnTpd(_ sender: Any) {
        self.isSocialSignUP = false
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.bgGrayLayer.alpha = 0.0
        }) { (isFinished) in
            self.bgGrayLayer.isHidden = true
            self.bgGrayLayer.alpha = 1.0
        }
    }
    
}

class OrganisationListTableViewCell : UITableViewCell
{
    
    @IBOutlet var lblName: UILabel!
    
}

