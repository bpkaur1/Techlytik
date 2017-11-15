//
//  SignUpViewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit
//import MBProgressHUD
import FacebookCore
import FacebookLogin
import FBSDKCoreKit

class SignUpViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate
{
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var organizationTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var fbBtn: UIButton!
    @IBOutlet weak var googlePlusBtn: UIButton!
    @IBOutlet weak var organizationBtn: UIButton!
    @IBOutlet weak var organizationDropDownTable: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var yourPictureBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var bgGrayLayer: UIView!
    @IBOutlet weak var organizationTableView1: UITableView!
    @IBOutlet weak var organizationTF1: UITextField!
    @IBOutlet weak var bgGrayView1: UIView!
    @IBOutlet weak var organizationBtn1: UIButton!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet var consTopLogo: NSLayoutConstraint!
    @IBOutlet var consTopView: NSLayoutConstraint!
    
    
    //Mark: variables/constants
    var organizationArray:NSMutableArray?
    var selectedOrganization:NSString?
    var isOrgDropdownHidden:Bool?
    var isOrgDropdownHidden1:Bool?
    var socialID:NSString?
    var usernmae:NSString?
    var profile_Picture:NSString?
    var isSocialSignUP:Bool = Bool()
    var isFacebookLogin:Bool = Bool()
    var myLoader = URActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOrganizations();
        
        isFacebookLogin = false;
        isSocialSignUP = false
        self.bgGrayView1.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let modelName = UIDevice.current.modelName
        if modelName == "iPhone 5" || modelName == "iPhone 5s" || modelName == "iPhone 5c" || modelName == "iPhone SE" || modelName == "iPhone 4" || modelName == "iPhone 4s" || modelName == "Simulators"
        {
            consTopLogo.constant = 30.0
            consTopView.constant = 0.0
            fbBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                           size: 9.5)
            googlePlusBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                         size: 9.5)
        }
        else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"  || modelName == "iPhone 8 Plus" || modelName == "Simulator"
        {
            consTopLogo.constant = 110.0
             consTopView.constant = 27.0
            
         if modelName != "iPhone X" || modelName == "Simulator"
            {
                fbBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                               size: 13.0)
                googlePlusBtn.titleLabel?.font = UIFont(name: "OpenSans-Semibold",
                                                             size: 13.0)
            }
        }
        
        let notificationName = Notification.Name(TKConstants.TK_GOOGLE_SIGNED_IN_NOTIFICATION)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.logingWithGoogle(notification:)), name: notificationName, object: nil)
        
        let notificationNameForIndicators = Notification.Name(TKConstants.TK_REMOVE_ANY_LAYER)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.removeIndicators), name: notificationNameForIndicators, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        adjustView();
    }
    
    func loadOrganizations(){
        organizationArray = NSMutableArray.init()
         myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        let url = URL(string: TKConstants.BASE_URL + TKConstants.ORGANIZATIONS)!
        
        let dataManager = TKDataManager()
        dataManager.downloadOrganizationsFromUrl(url: url as NSURL, viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            DispatchQueue.main.async {
                self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                MBProgressHUD.hide(for: self.view, animated:true)
            }
            if success {
                let orgTemp:NSArray = jsonDictionary.object(forKey: "DataArray") as! NSArray
                self.organizationArray = jsonDictionary.object(forKey: "DataArray") as? NSMutableArray
                print(self.organizationArray ?? "")
//                for i in 0 ..< orgTemp.count {
//                    let dictionary:NSDictionary = orgTemp[i] as! NSDictionary
//                    let orgName:String = String(dictionary.object(forKey: "label") as! String)
//                    self.organizationArray?.add(orgName);
//                }
                
                DispatchQueue.main.async {
                    self.organizationDropDownTable.reloadData()
                    self.organizationTableView1.reloadData()
                }
            }else{
                let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func adjustView(){
        addCornerRadiusToView(View: self.signUpBtn)
        addCornerRadiusToView(View: self.fbBtn)
        addCornerRadiusToView(View: self.googlePlusBtn)
        
        isOrgDropdownHidden = true
        isOrgDropdownHidden1 = true
        self.organizationDropDownTable.isHidden = true
        
        
//        self.yourPictureBtn.layer.cornerRadius = self.yourPictureBtn.frame.size.width/2
//        self.yourPictureBtn.clipsToBounds = true
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        let value = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["value"])! as? Int)!
        let name = (((self.organizationArray![indexPath.row] as? [String : AnyObject])?["label"])! as? String)!
        
        if(tableView.isEqual(self.organizationDropDownTable)){
           
            self.organizationTF.text = name
            
            isOrgDropdownHidden = true;
            UIView .animate(withDuration:0.1) {
                self.organizationDropDownTable.alpha = 0.0
                self.organizationDropDownTable.isHidden = self.isOrgDropdownHidden!
                self.organizationBtn.isUserInteractionEnabled = true
            }
            
            if isSocialSignUP {
                if self.bgGrayLayer != nil {
                    self.bgGrayLayer.isHidden = true;
                }
                loginUserWithServer(self.socialID!, self.profile_Picture!, self.usernmae!, String(value))
            }
        }else{
           
            self.organizationTF1.text = name
            isOrgDropdownHidden1 = true;
            UIView .animate(withDuration:0.1) {
                self.organizationTableView1.alpha = 0.0
                self.organizationTableView1.isHidden = self.isOrgDropdownHidden1!
                self.organizationBtn1.isUserInteractionEnabled = true
            }
            
            if isSocialSignUP {
                self.bgGrayView1.isHidden = true;
                loginUserWithServer(self.socialID!, self.profile_Picture!, self.usernmae!, String(value))
            }
        }
    }
    
    @IBAction func yourPictureBtnTpd(_ sender: Any)
    {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library")
        actionSheet.show(in: self.view)
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UIActionSheet Delegate Methods
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        switch (buttonIndex){
        case 0:
            print("Cancel")
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        case 2:
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        default:
            print("Default")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.saveImageDocumentDirectory(image: image)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Error!",message: "Failed to get image", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var Timestamp: String
    {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    //MARK: Save Image to documents directory
    func saveImageDocumentDirectory(image:UIImage)
    {
        self.userImageView.image = image
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2
        self.userImageView.clipsToBounds = true
    }
    
    @IBAction func fbBtnTpd(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.bgGrayView1.alpha = 0.0
        }) { (isFinished) in
            self.bgGrayView1.isHidden = false
            self.bgGrayView1.alpha = 1.0
        }
        isFacebookLogin = true
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.bgGrayView1.isHidden = true;
                print(error)
            case .cancelled:
                self.bgGrayView1.isHidden = true;
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
                            self.organizationBtnTpd1(self)
                        }
                    }else{
                        self.bgGrayView1.isHidden = true;
                        print(error?.localizedDescription ?? "Not found")
                    }
                })
            }
        }
    }
    
    func loginUserWithServer(_ socialID:NSString, _ profile_Picture:NSString, _ username:NSString, _ organization:String)
    {
         let myLoader = URActivityIndicator()
        var socialMedia = "Facebook"
        if isFacebookLogin
        {
            socialMedia = "Facebook"
        }
        else
        {
            socialMedia = "google"
        }
        
        let jsonParameters:NSDictionary = ["social_id":socialID, "name":"", "username":username, "email":"", "profile_picture":profile_Picture, "organization":self.organizationTF1.text!, "provider":socialMedia]
        
        let urlString = TKConstants.BASE_URL + TKConstants.SIGNUP_FACEBOOK as String
        
        let url = URL(string: urlString)! //change the url
        print("loginUserWithServer: \(urlString)")
        print("loginUserWithServer: \(jsonParameters)")
        
        let dataManager = TKDataManager()
         myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                if let val:Int64 = jsonDictionary.object(forKey: "errorCode") as? Int64 {
                    if val == 4002{
                        DispatchQueue.main.async {
                            self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                            MBProgressHUD.hide(for: self.view, animated:true)
                            let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
                                _ = self.navigationController?.popViewController(animated: true)
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
//                        MBProgressHUD.hide(for: self.view, animated:true)
                        self.performSegue(withIdentifier: TKConstants.TK_SHOW_MAPVIEW_ON_REGISTER, sender: self)
                    }
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
    
    
    @IBAction func googlePlusBtnTpd(_ sender: Any) {
        isFacebookLogin = false
        GIDSignIn.sharedInstance().signIn()
    }
    
    func logingWithGoogle(notification:NSNotification)
    {
        if let user = notification.userInfo?["user"] as? GIDGoogleUser
        {
            self.socialID = user.userID as NSString
            self.usernmae = user.profile.name as NSString
            if user.profile.hasImage{
                let imageUrl = user.profile.imageURL(withDimension: 120)
                self.profile_Picture = imageUrl?.absoluteString as NSString?
                print(" image url: ", imageUrl?.absoluteString as Any)
            }
            
            DispatchQueue.main.async {
                self.bgGrayView1.isHidden = false;
                self.isSocialSignUP = true
                self.organizationBtnTpd1(self)
            }
        }else{
            self.bgGrayView1.isHidden = true;
        }
    }
    
    func removeIndicators(){
        DispatchQueue.main.async {
            self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//            MBProgressHUD.hide(for: self.view, animated:true)
            
            if( self.bgGrayLayer != nil){
                self.bgGrayLayer.isHidden = true;
            }
        }
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
    
    
    @IBAction func signUpBtnTpd(_ sender: Any)
    {
        isSocialSignUP = false
        var showMessage:Bool = false
        let tkTutilies:TKUtilities = TKUtilities()
        var alertMessage:String = ""
        
        if (self.nameTF.text?.isEmpty)!
        {
            showMessage = true
            alertMessage = "Please provide your name"
        }
        else if (self.emailTF.text?.isEmpty)!
        {
            showMessage = true
            alertMessage = "Please provide email address"
        }
        else if (self.passwordTF.text?.isEmpty)!
        {
            showMessage = true
            alertMessage = "Please provide password"
        }
        else if (self.confirmPasswordTF.text?.isEmpty)!
        {
            showMessage = true
            alertMessage = "Please confirm your password"
        }
        else if(!tkTutilies.isValidEmail(testStr: self.emailTF.text!))
        {
            showMessage = true
            alertMessage = "Please provide a valid email address"
        }
        else if(self.organizationTF.text?.isEmpty)!
        {
            showMessage = true
            alertMessage = "Please choose your organization"
        }
        else if(self.passwordTF.text != self.confirmPasswordTF.text)
        {
            showMessage = true
            alertMessage = "Passwords don't match"
        }
        
        if showMessage
        {
            let alert = UIAlertController(title: "Error!", message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
             myLoader.showActivityIndicator(uiView: APPWINDOW!)
//            MBProgressHUD.showAdded(to: self.view, animated:true)
            
            let jsonParameters:NSDictionary = ["name":self.nameTF.text!, "email":self.emailTF.text!, "password":self.passwordTF.text!, "organization":self.organizationTF.text!]
            let url = URL(string: TKConstants.BASE_URL + TKConstants.SIGNUP)! //change the url
            
            let dataManager = TKDataManager()
            dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
                
                if success {
                    DispatchQueue.main.async {
                        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                        MBProgressHUD.hide(for: self.view, animated:true)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    DispatchQueue.main.async {
                        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                        MBProgressHUD.hide(for: self.view, animated:true)
                        
                        let alert = UIAlertController(title: "Error!", message: message as String, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func organizationBtnTpd1(_ sender: Any) {
        isOrgDropdownHidden1 = !isOrgDropdownHidden1!
        
        if isOrgDropdownHidden1! {
            self.organizationTableView1.alpha = 1.0
        }else{
            self.organizationTableView1.alpha = 0.0
        }
        
        //        self.organizationBtn.isUserInteractionEnabled = false
        UIView .animate(withDuration:0.1) {
            if(self.isOrgDropdownHidden1!){
                self.organizationTableView1.alpha = 0.0
            }else{
                self.organizationTableView1.alpha = 1.0
            }
            self.organizationTableView1.isHidden = self.isOrgDropdownHidden1!
            self.organizationBtn1.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        self.isSocialSignUP = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bgGrayView1.alpha = 0.0
        }) { (isFinished) in
            self.bgGrayView1.isHidden = true
            self.bgGrayView1.alpha = 1.0
        }
    }
    
    @IBAction func cancelBtnTpd(_ sender: Any)
    {
        self.isSocialSignUP = false
        UIView.animate(withDuration: 0.3, animations: {
            self.bgGrayView1.alpha = 0.0
        }) { (isFinished) in
            self.bgGrayView1.isHidden = true
            self.bgGrayView1.alpha = 1.0
        }
    }
}
