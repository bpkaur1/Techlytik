//
//  ConfigurationViewController.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
//import MBProgressHUD



class ConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, groupTableViewCellProtocol,ConfigurationDetailsProtocol, ControlCustomCellProtocol {
    
    
    
    //MARK: IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var configTableview: UITableView!

    
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    //MARK: Global Variables
    let CONFIG_TOP_CELL_IDENTIFIER = "ConfigTopCell"
    let CONFIG_TOP_CELL_HEIGHT:CGFloat = 204.0
    
    let SITE_IO_INFO_CELL_IDENTIFIER = "SiteIOCustomCell"
    let SITE_IO_INFO_CELL_HEIGHT:CGFloat = 270.0
    
    let SET_POINTS_CELL_IDENTIFIER = "SetPointsCustomCell"
    let SET_POINTS_CELL_HEIGHT:CGFloat = 276.0
    
    let CONTROL_CELL_IDENTIFIER = "ControlCustomCell"
    let CONTROL_CELL_HEIGHT:CGFloat = 207.0
    
    let GROUP_CUSTOM_CELL_IDENTIFIER = "groupTableViewCell"
    let GROUP_CUSTOM_CELL_HEIGHT:CGFloat = 45.0
    

    let HEADER_HEIGHT:CGFloat = 30.0
    
    
    
    var listArray:NSMutableArray?
    var headerTitles:NSArray?
    var groupsDictionary:NSDictionary?
    var registeredDevices:NSMutableArray?
    var selected_device_id:String?
    var myLoader = URActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialData()
        prepareUserInterface()
        
        
    }
    
    func loadInitialData() {
        
        groupsDictionary = NSMutableDictionary.init()
        registeredDevices = NSMutableArray.init()
        selected_device_id = UserDefaults.standard.object(forKey: TKConstants.TK_SELECTED_DEVICE_ID) as! String?
        headerTitles = NSArray.init(objects: selected_device_id!,"Site I/O", "Set Points", "Control")
        downloadConfigurations()
        
    }
    
    func downloadConfigurations()
    {
//        readJson()
            myLoader.showActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        
        let jsonString = "{\"Key\":\"api_storage\",\"Return\":[{\"table\":\"api_storage\",\"fields\":[\"api_key\",\"api_labels\",\"lookup_key\"]},{\"table\":\"lookup_api_values\",\"fields\":[\"group\",\"col_description\",\"sourcetype\",\"source\",\"labelvalues\"]}],\"conditions\":{\"device_id\":\"\(selected_device_id!)\"},\"SearchType\":\"contains\",\"G\":false,\"L\":0,\"GBY\":{\"table\":\"api_storage\",\"fields\":[\"api_key\",\"api_labels\",\"lookup_key\"]},\"join\":{\"joinType\":\"INNER\",\"joinStatement\":[{\"table\":\"lookup_api_values\",\"on\":[{\"parentTableField\":\"lookup_key\",\"childTableField\":\"id\"}]}]}}"
        
        let jsonParameters = NSMutableDictionary(dictionary: convertToDictionary(text: jsonString)!)
        
        let url = URL(string: TKConstants.BASE_URL + TKConstants.CONFIGURATIONS_API)! //change the url
        
        let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
        
        let dataManager = TKDataManager()
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, token:token, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                
                UserDefaults.standard.set(token, forKey: TKConstants.TK_TOKEN_CONSTANT)
                
                let gridArray:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "grid") as! Array<Dictionary<NSString,NSString>>
                
                for dataDictionary in gridArray {
                    if let val:NSString = dataDictionary["sourcetype"]! as NSString {
                        let groupName = dataDictionary["group"];
                        if let val:ConfigGroupDAO = self.groupsDictionary?[groupName!] as? ConfigGroupDAO {
                            let configDAO:ConfigGroupDAO = val;
                            configDAO.groupDataArray?.add(dataDictionary)
                            self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
                        }else{
                            let configDAO:ConfigGroupDAO = ConfigGroupDAO()
                            configDAO.groupName = groupName as? String
                            configDAO.groupDataArray = NSMutableArray.init()
                            configDAO.groupDataArray?.add(dataDictionary)
                            self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
                        }
                    }
                }
                
                if let register_devices:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "registeredDevices") as? Array<Dictionary<NSString,NSString>>{
                    for dataDictionary in register_devices {
                        let aStr = String(format: "%@", dataDictionary["device_id"]!)
                        self.registeredDevices?.add(aStr)
                    }
                }

                
                
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    self.configTableview.reloadData();
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
    
    private func readJson() {
        let file = Bundle.main.path(forResource: "response_json", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                print(json)
                
                
                let jsonDictionary:NSDictionary = json.object(forKey: "data") as! NSDictionary
                
                let gridArray:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "grid") as! Array<Dictionary<NSString,NSString>>
                
                for dataDictionary in gridArray {
                    let groupName = dataDictionary["group"];
                    if let val:NSString = dataDictionary["sourcetype"]! as NSString {
                        if val.length>0 {
                            if let val:ConfigGroupDAO = self.groupsDictionary?[groupName!] as? ConfigGroupDAO {
                                let configDAO:ConfigGroupDAO = val;
                                configDAO.groupDataArray?.add(dataDictionary)
                                self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
                            }else{
                                let configDAO:ConfigGroupDAO = ConfigGroupDAO()
                                configDAO.groupName = groupName as? String
                                configDAO.groupDataArray = NSMutableArray.init()
                                configDAO.groupDataArray?.add(dataDictionary)
                                self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
                            }
                        }
                   
                    }
                }
                
                if let register_devices:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "registeredDevices") as? Array<Dictionary<NSString,NSString>>{
                    for dataDictionary in register_devices {
                        let aStr = String(format: "%@", [dataDictionary["device_id"]] )
                        self.registeredDevices?.add(aStr)
                    }
                }

                
                self.configTableview.reloadData();

                
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func updateValueForGroupName(groupName: NSString, dataArray:NSMutableArray){
        
        let configDAO:ConfigGroupDAO = groupsDictionary?.object(forKey: groupName) as! ConfigGroupDAO
        configDAO.groupDataArray = dataArray
        self.groupsDictionary?.setValue(configDAO, forKey: groupName as String)
    }

    
    func prepareUserInterface(){
        self.configTableview.register(UINib.init(nibName: CONFIG_TOP_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: CONFIG_TOP_CELL_IDENTIFIER)
        
        self.configTableview.register(UINib.init(nibName: SITE_IO_INFO_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: SITE_IO_INFO_CELL_IDENTIFIER)
        
        self.configTableview.register(UINib.init(nibName: SET_POINTS_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: SET_POINTS_CELL_IDENTIFIER)
        
        self.configTableview.register(UINib.init(nibName: CONTROL_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: CONTROL_CELL_IDENTIFIER)
        
        self.configTableview.register(UINib.init(nibName: GROUP_CUSTOM_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: GROUP_CUSTOM_CELL_IDENTIFIER)
        
        self.configTableview.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    //MARK: UITableview delegate methods
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 4
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
         var rowsCount = 1;
        switch section {
        case 2:
            rowsCount = (groupsDictionary?.allKeys.count)!
        default:
            rowsCount = 1;
        }
        return rowsCount
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return HEADER_HEIGHT;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        var height:CGFloat = 46.0;
        
        switch indexPath.section {
        case 0:
            height = CONFIG_TOP_CELL_HEIGHT
            break
        case 1:
            height = SITE_IO_INFO_CELL_HEIGHT
            break
        case 2:
            height = GROUP_CUSTOM_CELL_HEIGHT
            if indexPath.row != 0 {
                height -= 5
            }
            
            break
        case 3:
            height = CONTROL_CELL_HEIGHT
            break
        default:
            height = 0.0
        }
        
        return height
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView:UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT));
        headerView.backgroundColor = UIColor.init(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
        
        let labelTitle:UILabel = UILabel.init(frame: CGRect(x: 18, y: 0, width: headerView.frame.size.width-36, height: headerView.frame.size.height))
        labelTitle.font = UIFont.init(name: "Helvetica-Regular", size: 14)
        labelTitle.text = headerTitles?.object(at: section) as! String?
        headerView.addSubview(labelTitle)
        
        if section == 0 {
            let dotsBtn:UIButton = UIButton.init(type: UIButtonType.system)
            dotsBtn.frame = CGRect(x: headerView.frame.size.width - 27, y: (headerView.frame.size.height-23)/2, width: 23, height: 23);
            dotsBtn.setBackgroundImage(UIImage(named:"whitedotsIcon.png"), for: UIControlState.normal)
            headerView .addSubview(dotsBtn)
        }
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: CONFIG_TOP_CELL_IDENTIFIER) as! ConfigTopCell?
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: SITE_IO_INFO_CELL_IDENTIFIER) as! SiteIOCustomCell?
            break
        case 2:
            
            let cell1:groupTableViewCell = (tableView.dequeueReusableCell(withIdentifier: GROUP_CUSTOM_CELL_IDENTIFIER) as! groupTableViewCell?)!
            
            let key = groupsDictionary?.allKeys[indexPath.row]
            let configDAO:ConfigGroupDAO = groupsDictionary?.object(forKey: key!) as! ConfigGroupDAO
            
            cell1.titleLabel.text = configDAO.groupName

            if(indexPath.row != 0) {
                cell1.topLine.isHidden = true
            }
                
            
            var icnImageName = "analogIcn.png"
            
            switch configDAO.groupName {
            case "Digital Inputs"?:
                icnImageName = "digitalIcn.png"
                
                cell1.icn_leading_constraint.constant = 11
                cell1.icn_width_constraint.constant = 31
                cell1.icn_height_constraint.constant = 20
                
                break
            case "Analog Inputs"?:
                icnImageName = "analogIcn.png"
                
                cell1.icn_leading_constraint.constant = 10
                cell1.icn_width_constraint.constant = 29
                cell1.icn_height_constraint.constant = 19
                
                break
            case "Power Monitorin"?:
                icnImageName = "powerMonitoringIcn.png"
                
                cell1.icn_leading_constraint.constant = 19
                cell1.icn_width_constraint.constant = 16
                cell1.icn_height_constraint.constant = 22
                
                break
            case "Communications"?:
                icnImageName = "communcation.png"
                
                cell1.icn_leading_constraint.constant = 17
                cell1.icn_width_constraint.constant = 20
                cell1.icn_height_constraint.constant = 22
                
                break
            case "Pump Control"?:
                icnImageName = "pumpControl.png"
                
                cell1.icn_leading_constraint.constant = 15
                cell1.icn_width_constraint.constant = 23
                cell1.icn_height_constraint.constant = 27
                
                break
            case "Pump Equipment"?:
                icnImageName = "range.png"
                
                cell1.icn_leading_constraint.constant = 13
                cell1.icn_width_constraint.constant = 27
                cell1.icn_height_constraint.constant = 26
                
                break
            default:
                icnImageName = "digitalIcn.png"
                
                cell1.icn_leading_constraint.constant = 11
                cell1.icn_width_constraint.constant = 31
                cell1.icn_height_constraint.constant = 20
                
                break
                
            }
            
            cell1.iconImageView.image = UIImage.init(named: icnImageName)
            cell1.delegate = self;
            cell1.plusBtn.tag = indexPath.row
           cell = cell1
            break
        case 3:
            let cellCustom:ControlCustomCell = (tableView.dequeueReusableCell(withIdentifier: CONTROL_CELL_IDENTIFIER) as! ControlCustomCell?)!
            cellCustom.delegate = self
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor.blue
            toolBar.backgroundColor = UIColor.black
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ConfigurationViewController.donePressed))
            
            toolBar.setItems([doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            toolBar.sizeToFit()
            
            cellCustom.selectedDeviceTF.inputAccessoryView = toolBar
            
            let DDArray:NSArray? = registeredDevices! as NSArray
            cellCustom.selectedDeviceTF.itemList = DDArray as! [String]?
            if (DDArray?.count)!>0 {
                cellCustom.selectedDeviceTF.selectedItem = DDArray?.object(at: 0) as? String
            }
            
            cell = cellCustom
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CONFIG_TOP_CELL_IDENTIFIER) as! ConfigTopCell?
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }

    func donePressed()  {
        self.view.endEditing(true)
        let indexPath = NSIndexPath(row: 0, section: 3)
        let cellCustom:ControlCustomCell = self.configTableview.cellForRow(at: indexPath as IndexPath) as! ControlCustomCell
        
        if let device_id = cellCustom.selectedDeviceTF.selectedItem {
            //call clone API now
            callCloneAPI(deviceId: device_id)
        }
        
    }
    
    func callCloneAPI(deviceId:String){
        
        self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//        MBProgressHUD.showAdded(to: self.view, animated:true)
        
        
        
        let jsonString = "{\"CLONEFROM\":\"\(deviceId)\",\"TOCONFIGURE\":\"100 01-13-042-08W5 00\",\"Type\":\"frominstalleddevice\"}"
        
        let jsonParameters = NSMutableDictionary(dictionary: convertToDictionary(text: jsonString)!)
        print(jsonParameters)
        
        let url = URL(string: TKConstants.BASE_URL + TKConstants.CONFIGURATIONS_CLONE)! //change the url
        
        let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
        
        let dataManager = TKDataManager()
        dataManager.downloadDataFromUrl(url: url as NSURL, jsonParameters: jsonParameters, token:token, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
                
//                UserDefaults.standard.set(token, forKey: TKConstants.TK_TOKEN_CONSTANT)
//                
//                let gridArray:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "grid") as! Array<Dictionary<NSString,NSString>>
//                
//                for dataDictionary in gridArray {
//                    let groupName = dataDictionary["group"];
//                    if let val:ConfigGroupDAO = self.groupsDictionary?[groupName!] as? ConfigGroupDAO {
//                        let configDAO:ConfigGroupDAO = val;
//                        configDAO.groupDataArray?.add(dataDictionary)
//                        self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
//                    }else{
//                        let configDAO:ConfigGroupDAO = ConfigGroupDAO()
//                        configDAO.groupName = groupName as? String
//                        configDAO.groupDataArray = NSMutableArray.init()
//                        configDAO.groupDataArray?.add(dataDictionary)
//                        self.groupsDictionary?.setValue(configDAO, forKey: groupName as! String)
//                    }
//                }
                
//                if let register_devices:Array<Dictionary<NSString,NSString>> = jsonDictionary.object(forKey: "registeredDevices") as? Array<Dictionary<NSString,NSString>>{
//                    for dataDictionary in register_devices {
//                        self.registeredDevices?.add([dataDictionary["device_id"]])
//                    }
//                }
                
                
                
                DispatchQueue.main.async {
                    self.myLoader.hideActivityIndicator(uiView: APPWINDOW!)
//                    MBProgressHUD.hide(for: self.view, animated:true)
                    
                    let alert = UIAlertController(title: "Clone successful", message: "Set points cloned successfully" as String, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
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
    
    
    //MARK: Set Points Custom Cell Delegate methods
    func detailBtnTpdForIndex(index: Int) {
       print(groupsDictionary!)
        let key = groupsDictionary?.allKeys[index]
        let configDAO:ConfigGroupDAO = groupsDictionary?.object(forKey: key!) as! ConfigGroupDAO
        
//        let configDAO:ConfigGroupDAO = groupsDictionary?.object(forKey: index) as! ConfigGroupDAO
        let configDetailsController:ConfigurationDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfigurationDetailsViewController") as! ConfigurationDetailsViewController;
        configDetailsController.delegate = self
        configDetailsController.groupTitle = configDAO.groupName as NSString?
        configDetailsController.listArray = configDAO.groupDataArray
        _ = self.navigationController?.pushViewController(configDetailsController, animated: true)

        
//        _ = self.performSegue(withIdentifier: "configDetails", sender: self)
        
    }

    
    func  cloneAllSetPointsAPICall(cell: ControlCustomCell) {
        cell.selectedDeviceTF.becomeFirstResponder()
    }
}
