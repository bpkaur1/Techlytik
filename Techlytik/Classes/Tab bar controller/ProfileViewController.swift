//
//  ProfileViewController.swift
//  Techlytik
//
//  Created by Waheguru on 10/11/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import UIKit
//import MBProgressHUD
import DropDown

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate
{
    //MARK : IBOutlets
    // Constraint Outlets
    @IBOutlet var consTopPhnNo: NSLayoutConstraint!
    @IBOutlet var consTopSms: NSLayoutConstraint!
    @IBOutlet var consTopNoti: NSLayoutConstraint!
    @IBOutlet var consTopDefault: NSLayoutConstraint!
    @IBOutlet var consBtnLogout: NSLayoutConstraint!
    
    // Labels Outlets
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblDeviceId: UILabel!
    @IBOutlet var lblPhnNo: UILabel!
    
    // Imageview Outlet
    @IBOutlet var ivProfile: UIImageView!
    
    // Switch Outlet
    @IBOutlet var swSmsNoti: UISwitch!
    @IBOutlet var swNoti: UISwitch!
    
    // Button Outlet
    @IBOutlet var btnFieldName: UIButton!
    @IBOutlet var btnOperatorRunNo: UIButton!
    
    //MARK : Constant/Variavles
    var dictProfile = NSDictionary()
    var aryOperatorrun = Array<Dictionary<String, Any>>()
    var aryFields = Array<Dictionary<String, Any>>()
    var aryFieldsDD = [String]()
    var aryOperatorDD = [String]()
    var myLoader = URActivityIndicator()
    
    let fieldDropDown = DropDown()
    let operatorDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.fieldDropDown,
            self.operatorDropDown
        
        ]
    }()
    
    //MARK: View Did Load
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title = "PROFILE"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Add Add & Search Button on navigation
        let adBarButtons = NavigationBarButtonActions()
        adBarButtons.AddBarButtons(navCont: self.navigationController!, navItem: self.navigationItem)
        
        // Set the View According To Screen Sizes
        let modelName = UIDevice.current.modelName
        if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus"  || modelName == "iPhone 8 Plus" || modelName == "iPhone 6" || modelName == "iPhone 6s"  || modelName == "iPhone 7" || modelName == "iPhone 8" || modelName == "Simulator"
        {
            consTopPhnNo.constant = 20
            consTopSms.constant = 20
            consTopNoti.constant = 20
            consTopDefault.constant = 20
            consBtnLogout.constant = 40
        }
        
        CallWebserviceToGetProfileData()
    }
    
    //MARK: Buttons IBACTIONS
    @IBAction func SelectProfilePic(_ sender: Any)
    {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library")
        actionSheet.show(in: self.view)
    }
    
    @IBAction func EditPhoneNo(_ sender: Any)
    {
        let cntr = self.storyboard?.instantiateViewController(withIdentifier: "editphn")as! ProfileEditPhoneNumber
        cntr.view.backgroundColor = UIColor.clear;
        cntr.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(cntr, animated: true, completion: nil)
    }
    
    @IBAction func SelectFieldName(_ sender: Any)
    {
        fieldDropDown.show()
    }
    
    @IBAction func SelectOperatorNo(_ sender: Any)
    {
        operatorDropDown.show()
    }
    
    @IBAction func LogOut(_ sender: Any)
    {
        self.alertFunction(mssg: "Do you want to Logout?")
       
    }
    
    func alertFunction(mssg:String)
    {
        var alertController : UIAlertController!
        alertController = UIAlertController(title: "TECHLYTIK", message: mssg, preferredStyle: .alert)
        let YesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            
            let userDAO =  UserDAO.init(token: "", id: 0, username: "", img: "", org: "")
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: userDAO)
            UserDefaults.standard.set(encodedData, forKey: TKConstants.TK_USER_DAO)
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let cntrSplashVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navRoot") as! UINavigationController;
            appdelegate.window!.rootViewController = cntrSplashVC
            
        }
        let No = UIAlertAction(title: "No", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
        }
        alertController.addAction(YesAction)
        alertController.addAction(No)
        self.present(alertController, animated: true, completion:nil)
    }
    
    //MARK: Dropdown Functions
    
    func setupDropDowns()
    {
        setupFieldDropDown()
        setupOperatorDropDown()
        customizeDropDown(self)
    }
    
    func setupFieldDropDown()
    {
        fieldDropDown.anchorView = btnFieldName
        fieldDropDown.bottomOffset = CGPoint(x: 0, y: btnFieldName.bounds.height)
        
        for i in 0..<aryFields.count
        {
            aryFieldsDD.append(aryFields[i]["field_name"] as! String)
        }
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        fieldDropDown.dataSource = aryFieldsDD
        
        // Action triggered on selection
        fieldDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnFieldName.setTitle("  \(item)", for: .normal)
        }
    }
    
    func setupOperatorDropDown()
    {
        operatorDropDown.anchorView = btnOperatorRunNo
        operatorDropDown.bottomOffset = CGPoint(x: 0, y: btnOperatorRunNo.bounds.height)
        for i in 0..<aryOperatorrun.count
        {
            aryOperatorDD.append(aryOperatorrun[i]["field_value"] as! String)
        }
        // You can also use localizationKeysDataSource instead. Check the docs.
        operatorDropDown.dataSource = aryOperatorDD
        // Action triggered on selection
        operatorDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnOperatorRunNo.setTitle("  \(item)", for: .normal)
        }
    }
    
    func customizeDropDown(_ sender: AnyObject)
    {
        let appearance = DropDown.appearance()
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = UIColor(red: 209/255, green: 41/255, blue: 85/255, alpha: 1.0)
        //appearance.textFont = UIFont(name: "Georgia", size: 14)
        
        dropDowns.forEach
            {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "MyCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            }
            /*** ---------------- ***/
        }
    }
    
    //MARK: UIActionSheet Delegate Methods
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        switch (buttonIndex)
        {
        case 0:
            print("Cancel")
        case 1:
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera)
            {
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
            //Some code here..
        }
    }
    
    //MARK: UIImagePicker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivProfile.layer.cornerRadius = ivProfile.frame.size.width/2
        ivProfile.layer.masksToBounds = true
        ivProfile.image = image
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer)
    {
        if error != nil
        {
            let alert = UIAlertController(title: "Error!",message: "Failed to get image", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func CallWebserviceToGetProfileData()
    {
        let urlString = "\(TKConstants.BASE_URL + TKConstants.GET_PROFILE as String)/?id=11"
        let url = URL(string: urlString)! //change the url
        print("URL: \(url)")
        print("loginUserWithServer: \(urlString)")
        let dataManager = TKDataManager()
        let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
        print(token)
        DispatchQueue.main.async {
//            MBProgressHUD.showAdded(to: self.view, animated:true)
             self.myLoader.showActivityIndicator(uiView: APPWINDOW!)
        }
        
        dataManager.downloadDataFromUrlWithParemetersInUrlUsingToken(url: url as NSURL, viewController: self, token: token, completionHandler: { (success, jsonDictionary, message, token) in
            if success
            {
                UserDefaults.standard.set(token, forKey: TKConstants.TK_TOKEN_CONSTANT)
                print(jsonDictionary)
                print(token)
                
                self.aryFields = (jsonDictionary.object(forKey: "fields") as? Array<Dictionary<String, Any>>)!
                print(self.aryFields)
                
                self.aryOperatorrun = (jsonDictionary.object(forKey: "operatorRun") as? Array<Dictionary<String, Any>>)!
                print(self.aryOperatorrun)
                
                self.dictProfile = (jsonDictionary.object(forKey: "profile") as? NSDictionary)!
                print(self.dictProfile)
                
                DispatchQueue.main.async
                    {
                        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                        MBProgressHUD.hide(for: self.view, animated:true)
                        self.lblName.text = self.dictProfile["name"] as? String
                        self.lblEmail.text = self.dictProfile["email"] as? String
                        self.lblDeviceId.text = self.dictProfile["last_active"] as? String
                        
                        let operatorNo = self.dictProfile["defaultoperatorrun"] as? Int
                        self.btnOperatorRunNo.setTitle("  \(String(describing: operatorNo!))", for: UIControlState.normal)
                        
                        let fieldName = self.dictProfile["defaultfield"] as? String
                        self.btnFieldName.setTitle("  \(fieldName!)", for: UIControlState.normal)
                        
                        let imgurl : String! = self.dictProfile["profile_picture"] as? String
                        let urlImage = "\(TKConstants.BASE_URL)\(imgurl!)"
                        
                        if urlImage != ""
                        {
                            let newUrl = URL(string: urlImage)!
                            let data = NSData(contentsOf: newUrl as URL)
                            self.ivProfile.image = UIImage(data: data! as Data)
                            self.ivProfile.layer.cornerRadius = self.ivProfile.frame.size.width/2
                            self.ivProfile.layer.masksToBounds = true
                        }
                        
                        let smsNoti = self.dictProfile["smsnotifications"] as! Int
                        if smsNoti == 0
                        {
                            self.swSmsNoti.setOn(false, animated: true)
                        }
                        else
                        {
                            self.swSmsNoti.setOn(true, animated: true)
                        }
                        
                        let Noti = self.dictProfile["notifications"] as! Int
                        if Noti == 0
                        {
                            self.swNoti.setOn(false, animated: true)
                        }
                        else
                        {
                            self.swNoti.setOn(true, animated: true)
                        }
                        
                        self.setupDropDowns()
                }
            }
            else
            {
                DispatchQueue.main.async
                    {
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

class ProfileEditPhoneNumber: UIViewController, UITextFieldDelegate
{
    @IBOutlet var tfPhoneNumber: UITextField!
    
    //MARK: UItextField Delegates
    
    override func viewDidLoad()
    {
        self.tfPhoneNumber.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func Cancel(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SavePhoneNumber(_ sender: Any)
    {
    }
}
