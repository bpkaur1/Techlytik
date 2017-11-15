//
//  ProfileViewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation

class ProfileViewControllerssss: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfilePhotoCustomCellProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate {
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    //MARK: IBOutlets
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    //MARK: Global Variables
    let PHOTO_CELL_IDENTIFIER = "ProfilePhotoCustomCell"
    let PHOTO_CELL_HEIGHT:CGFloat = 74.0
    
    let BASIC_INFO_CELL_IDENTIFIER = "ProfileBasicInfoCustomCell"
    let BASIC_INFO_CELL_HEIGHT:CGFloat = 84.0
    
    let USER_CONTACT_CELL_IDENTIFIER = "UserContactInfoCustomCell"
    let USER_CONTACT_CELL_HEIGHT:CGFloat = 46.0
    
    let NOTIFICATION_CELL_IDENTIFIER = "NotificationsCustomCell"
    let NOTIFICATION_CELL_HEIGHT:CGFloat = 46.0
    
    let DEFAULT_FIELD_CELL_IDENTIFIER = "DefaultFieldAndRunCustomCell"
    let DEFAULT_FIELD_CELL_HEIGHT:CGFloat = 93.0
    
    let COMPANY_INFO_CELL_IDENTIFIER = "CompanyInformationCustomCell"
    let COMPANY_INFO_CELL_HEIGHT:CGFloat = 170.0
    
    let HEADER_HEIGHT:CGFloat = 30.0
    
    var listArray:NSMutableArray?
    var headerTitles:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Add & Search Button on navigation
        let adBarButtons = NavigationBarButtonActions()
       adBarButtons.AddBarButtons(navCont: self.navigationController!, navItem: self.navigationItem)
        
        loadInitialData()
        prepareUserInterface()
        
        self.title = "PROFILE"
        
    }
    
    func loadInitialData() {
        headerTitles = NSArray.init(objects: "","Basic Information", "User Contact Information", "Notifications", "Default Field and Run", "Company Information")
        
        addCornerRadiusToView(View: self.logoutBtn)
    }
    
    func prepareUserInterface(){
        self.profileTableView.register(UINib.init(nibName: PHOTO_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: PHOTO_CELL_IDENTIFIER)
        
        self.profileTableView.register(UINib.init(nibName: BASIC_INFO_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: BASIC_INFO_CELL_IDENTIFIER)
        
        self.profileTableView.register(UINib.init(nibName: NOTIFICATION_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: NOTIFICATION_CELL_IDENTIFIER)
        
        self.profileTableView.register(UINib.init(nibName: USER_CONTACT_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: USER_CONTACT_CELL_IDENTIFIER)
        
        self.profileTableView.register(UINib.init(nibName: DEFAULT_FIELD_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: DEFAULT_FIELD_CELL_IDENTIFIER)
        
        self.profileTableView.register(UINib.init(nibName: COMPANY_INFO_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: COMPANY_INFO_CELL_IDENTIFIER)
        
        self.profileTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }

    
    @IBAction func logoutBtnTpd(_ sender: Any) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: UITableview delegate methods
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 6
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        var height:CGFloat = 46.0
        
        if section == 0 {
            height = 0.0
        }else{
            height = HEADER_HEIGHT
        }
        
        return height;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        var height:CGFloat = 46.0;
        
        switch indexPath.section {
        case 0:
            height = PHOTO_CELL_HEIGHT
            break
        case 1:
            height = BASIC_INFO_CELL_HEIGHT
            break
        case 2:
            height = USER_CONTACT_CELL_HEIGHT
            break
        case 3:
            height = NOTIFICATION_CELL_HEIGHT
            break
        case 4:
            height = DEFAULT_FIELD_CELL_HEIGHT
            break
        case 5:
            height = COMPANY_INFO_CELL_HEIGHT
            break
        default:
            height = 0.0
        }
        
        return height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0{
            return nil
        }else {
            let headerView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT));
            headerView.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            
            let labelTitle:UILabel = UILabel.init(frame: CGRect(x: 18, y: 0, width: headerView.frame.size.width-36, height: headerView.frame.size.height))
            labelTitle.font = UIFont.init(name: "Helvetica-Regular", size: 14)
            labelTitle.text = headerTitles?.object(at: section) as! String?
            headerView.addSubview(labelTitle)
            
            return headerView
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        
        switch indexPath.section {
        case 0:
            let cell1:ProfilePhotoCustomCell = (tableView.dequeueReusableCell(withIdentifier: PHOTO_CELL_IDENTIFIER) as! ProfilePhotoCustomCell?)!
            cell1.delegate = self
            cell = cell1
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: BASIC_INFO_CELL_IDENTIFIER) as! ProfileBasicInfoCustomCell?
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: USER_CONTACT_CELL_IDENTIFIER) as! UserContactInfoCustomCell?
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: NOTIFICATION_CELL_IDENTIFIER) as! NotificationsCustomCell?
            break
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: DEFAULT_FIELD_CELL_IDENTIFIER) as! DefaultFieldAndRunCustomCell?
            break
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: COMPANY_INFO_CELL_IDENTIFIER) as! CompanyInformationCustomCell?
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: PHOTO_CELL_IDENTIFIER) as! ProfilePhotoCustomCell?
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    
    func photoEditTpd(sender: ProfilePhotoCustomCell) {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library")
        actionSheet.show(in: self.view)
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
            //Some code here..
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
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
    
    var Timestamp: String {
        return "\(NSDate().timeIntervalSince1970 * 1000)"
    }
    
    //MARK: Save Image to documents directory
    func saveImageDocumentDirectory(image:UIImage){
        let indexPath:NSIndexPath = NSIndexPath(row: 0, section: 0)
        let cell:ProfilePhotoCustomCell = self.profileTableView.cellForRow(at: indexPath as IndexPath) as! ProfilePhotoCustomCell
        cell.profileImageView.image = image
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2
        cell.profileImageView.clipsToBounds = true
        
    }
 
}
