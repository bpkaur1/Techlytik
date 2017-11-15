//
//  ConfigurationDetailsViewController.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
//import MBProgressHUD

protocol ConfigurationDetailsProtocol:class {
    func updateValueForGroupName(groupName: NSString, dataArray:NSMutableArray)
}

class ConfigurationDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConfigDetailCell1Protocol, IQDropDownTextFieldDelegate, UITextFieldDelegate {
    
    weak var delegate:ConfigurationDetailsProtocol?
    
    //MARK: IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var configDetailsTableview: UITableView!
    @IBOutlet weak var mainGroupTitle: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    
    //MARK: Global Variables
    let CONFIG_DETAILS_CELL = "ConfigDetailCell1"
    let CONFIG_DETAILS_CELL_HEIGHT:CGFloat = 30.0
    
    let CONFIR_DETAILS_INPUT_CELL = "ConfigInputDetailsCell"
    let CONFIG_DETAILS_INPUT_CELL_HEIGHT:CGFloat = 30.0
    
    let HEADER_HEIGHT:CGFloat = 30.0
    
    var listArray:NSMutableArray?
    var dropDownArray:NSArray?
    var groupTitle:NSString?
    var selected_device_id:String?
    var myLoader = URActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selected_device_id = UserDefaults.standard.object(forKey: TKConstants.TK_SELECTED_DEVICE_ID) as! String?
        loadInitialData()
        prepareUserInterface()
        
        mainGroupTitle.text = groupTitle as String?
        
        
        var icnImageName = "analogIcn.png"
        
        switch groupTitle {
        case "Digital Inputs"?:
            icnImageName = "digitalIcn.png"
            break
        case "Analog Inputs"?:
            icnImageName = "analogIcn.png"
            break
        case "Power Monitorin"?:
            icnImageName = "powerMonitoringIcn.png"
            break
        case "Communications"?:
            icnImageName = "communcation.png"
            break
        case "Pump Control"?:
            icnImageName = "pumpControl.png"
            break
        case "Pump Equipment"?:
            icnImageName = "range.png"
            break
        default:
            icnImageName = "digitalIcn.png"
            break
            
        }
        
        iconImageView.image = UIImage.init(named: icnImageName)
    }
    
    func loadInitialData() {
        
//        let dict1:NSDictionary = ["Title":"AnalogInput1_Status","Value":"Enable"]
//        let dict2:NSDictionary = ["Title":"AnalogInput1_Name","Value":"Enable"]
//        let dict3:NSDictionary = ["Title":"AnalogInput1_Min","Value":"Disable"]
//        let dict4:NSDictionary = ["Title":"AnalogInput1_Max","Value":"Enable"]
//        let dict5:NSDictionary = ["Title":"AnalogInput1_High_hi","Value":"Disable"]
//        let dict6:NSDictionary = ["Title":"AnalogInput1_High","Value":"Enable"]
//        let dict7:NSDictionary = ["Title":"AnalogInput1_High_br","Value":"Disable"]
//        let dict8:NSDictionary = ["Title":"AnalogInput1_Status","Value":"Enable"]
//        
//        
//        listArray = NSMutableArray.init()
//        listArray?.add(dict1);
//        listArray?.add(dict2);
//        listArray?.add(dict3);
//        listArray?.add(dict4);
//        listArray?.add(dict5);
//        listArray?.add(dict6);
//        listArray?.add(dict7);
//        listArray?.add(dict8);
        
        dropDownArray = ["Enable","Disable"]
        
    }
    
    func prepareUserInterface(){
        self.configDetailsTableview.register(UINib.init(nibName: CONFIG_DETAILS_CELL, bundle: nil), forCellReuseIdentifier: CONFIG_DETAILS_CELL)
        
        self.configDetailsTableview.register(UINib.init(nibName: CONFIR_DETAILS_INPUT_CELL, bundle: nil), forCellReuseIdentifier: CONFIR_DETAILS_INPUT_CELL)
        
        self.configDetailsTableview.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    @IBAction func backBtntpd(_ sender: Any) {
        self.delegate?.updateValueForGroupName(groupName: groupTitle!, dataArray: listArray!)
        _ = self.navigationController?.popViewController(animated: true)
    }
   
    
    //MARK: UITableview delegate methods
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (listArray?.count)!
    }

    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return CONFIG_DETAILS_CELL_HEIGHT
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell:UITableViewCell?
        let dict:NSDictionary = self.listArray?.object(at: indexPath.row) as! NSDictionary
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue
        toolBar.backgroundColor = UIColor.black
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ConfigurationDetailsViewController.donePressed))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        var selectedValue:NSString = ""
        if let api_label = dict.object(forKey: "api_labels") {
            if api_label is NSNull {
                
            }else{
                selectedValue = NSString(format:"%@", api_label as! CVarArg)
                selectedValue = selectedValue.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
            }
        }
        
        
        let sourceType:NSString = dict.object(forKey: "sourcetype") as! NSString
        if sourceType == "inline" { //Dropdown
            let cellCustom:ConfigDetailCell1 = (tableView.dequeueReusableCell(withIdentifier: CONFIG_DETAILS_CELL) as! ConfigDetailCell1?)!
            
            let dropDownArrayValues:NSMutableArray = NSMutableArray.init()
            if let sourceArray:Array<Dictionary<NSString,NSString>> = dict.object(forKey: "source") as? Array<Dictionary<NSString,NSString>> {
                for dataDictionary in sourceArray {
                    var aStr = String(format: "%@", dataDictionary["label"]! )
                        
                    aStr = aStr.capitalized
                    aStr = aStr.trimmingCharacters(in: .whitespacesAndNewlines)

                    dropDownArrayValues.add(aStr)
                }
            }else if let sourceArray:Array<Dictionary<NSString,Any>> = dict.object(forKey: "source") as? Array<Dictionary<NSString,Any>>{
                for dataDictionary in sourceArray {
                    
                    var aStr = ""
                    
                    if (dataDictionary["label"] as? Int) != nil {
                        aStr = String(format: "%d", dataDictionary["label"] as! Int! )
                    }else if (dataDictionary["label"] as? Float) != nil {
                        aStr = String(format: "%d", dataDictionary["label"] as! Float! )
                    }
                    aStr = aStr.capitalized
                    aStr = aStr.trimmingCharacters(in: .whitespacesAndNewlines)
                    dropDownArrayValues.add(aStr)
                }
            }
            
            let DDArray:NSArray? = dropDownArrayValues as NSArray

            cellCustom.valueTF.itemList = DDArray as! [String]?
//            cellCustom.valueTF.selectedItem = DDArray?.object(at: 0) as? String
            if selectedValue.length > 0{
                cellCustom.valueTF.selectedItem = selectedValue as String
            }else{
                cellCustom.valueTF.selectedItem = DDArray?.object(at: 0) as? String
            }

            cellCustom.delegate = self
            cellCustom.dropdownBtn.tag = indexPath.row
            cellCustom.titleLbl.text = dict.object(forKey: "api_key") as! String?
            cellCustom.valueTF.inputAccessoryView = toolBar
            cellCustom.valueTF.tag = indexPath.row
            cellCustom.valueTF.delegate = self
            
            
            cellCustom.databaseValuesDownloadBtn.isHidden = true;
            cellCustom.databaseValuesDownloadBtn.isEnabled = false;
            cell = cellCustom
            
        }else if(sourceType == "database"){ //Call API
            let cellCustom:ConfigDetailCell1 = (tableView.dequeueReusableCell(withIdentifier: CONFIG_DETAILS_CELL) as! ConfigDetailCell1?)!
            cellCustom.databaseValuesDownloadBtn.isHidden = false;
            cellCustom.databaseValuesDownloadBtn.isEnabled = true;
            cellCustom.dropdownBtn.tag = indexPath.row
            cellCustom.delegate = self
            cellCustom.titleLbl.text = dict.object(forKey: "api_key") as! String?
            cellCustom.valueTF.inputAccessoryView = toolBar
            cellCustom.valueTF.delegate = self
            
            
            if selectedValue.length > 0{
                let DDArray = NSArray.init(object: selectedValue)
                cellCustom.valueTF.itemList = DDArray as? [String]
                cellCustom.valueTF.selectedItem = selectedValue as String
            }else{
                cellCustom.valueTF.selectedItem = ""
            }
            
            
            cellCustom.bringSubview(toFront: cellCustom.databaseValuesDownloadBtn);
            cellCustom.valueTF.tag = indexPath.row
            cell = cellCustom
            
        }else if(sourceType == "input"){ //Show TF
            let cellCustom:ConfigInputDetailsCell = (tableView.dequeueReusableCell(withIdentifier: CONFIR_DETAILS_INPUT_CELL) as! ConfigInputDetailsCell?)!
            
            if selectedValue.length>0 {
                cellCustom.valueTF.text = selectedValue as String
            }else{
                cellCustom.valueTF.placeholder = "Enter value here..."
            }
            cellCustom.titleLbl.text = dict.object(forKey: "api_key") as! String?
            cellCustom.valueTF.delegate = self
            cellCustom.valueTF.tag = indexPath.row
            cell = cellCustom
        }else{
            let cellCustom:ConfigInputDetailsCell = (tableView.dequeueReusableCell(withIdentifier: CONFIR_DETAILS_INPUT_CELL) as! ConfigInputDetailsCell?)!
            
            if selectedValue.length>0 {
                cellCustom.valueTF.text = selectedValue as String
            }else{
                cellCustom.valueTF.placeholder = "Enter value here..."
            }
            cellCustom.titleLbl.text = dict.object(forKey: "api_key") as! String?
            cellCustom.valueTF.delegate = self
            cellCustom.valueTF.tag = indexPath.row
            cell = cellCustom
        }
        
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    func donePressed()  {
        self.view.endEditing(true)
        
    }
    
    //MARK: IQDropdownTextfield delegate methods
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String) {
        let row = textField.tag
        let dictTemp:NSDictionary = self.listArray?.object(at: row) as! NSDictionary
        let dict = dictTemp.mutableCopy()
        if let api_label = (dict as AnyObject).object(forKey: "api_labels") {
            print(api_label)
            (dict as AnyObject).setValue(textField.selectedItem, forKey: "api_labels")
            self.listArray?.replaceObject(at: row, with: dict)
        }
        
        //Call save API
        saveAPICall(dict: dict as! NSMutableDictionary)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField){
        let row = textField.tag
        let dictTemp:NSDictionary = self.listArray?.object(at: row) as! NSDictionary
        let dict = dictTemp.mutableCopy()
        if let api_label = (dict as AnyObject).object(forKey: "api_labels") {
            print(api_label)
            (dict as AnyObject).setValue(textField.text, forKey: "api_labels")
            self.listArray?.replaceObject(at: row, with: dict)
        }
        
        //Call save API
        saveAPICall(dict: dict as! NSMutableDictionary)
    }
    
    func saveAPICall(dict:NSMutableDictionary){

         let api_label = (dict as AnyObject).object(forKey: "api_labels")
         let look_up_key = (dict as AnyObject).object(forKey: "lookup_key")
        
        let api_label_str = NSString(format:"%@", api_label as! CVarArg)
        let look_up_key_str = NSString(format:"%@", look_up_key as! CVarArg)
        
        let jsonString = "{\"Key\": \"api_storage\",\"where\": {\"device_id\": \"\(selected_device_id!)\",\"lookup_key\": \"\(look_up_key_str)\"},\"updateAttributes\": {\"api_value\": 0,\"api_labels\": \"\(api_label_str)\"}}"
        print(jsonString)
        let jsonParameters = NSMutableDictionary(dictionary: convertToDictionary(text: jsonString)!)
        
        let url = URL(string: TKConstants.BASE_URL + TKConstants.CONFIGURATIONS_UPDATE)! //change the url
        
        let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
        
        let dataManager = TKDataManager()
        dataManager.updateInSilentMode(url: url as NSURL, jsonParameters: jsonParameters, token:token, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary, message, token) in
            
            if success {
            }else{
            }
        })
    }
    
    func dropDownTpdFor(tag: Int) {
        let indexPath:NSIndexPath = NSIndexPath(row: tag, section: 0)
        let cell:ConfigDetailCell1 = self.configDetailsTableview.cellForRow(at: indexPath as IndexPath) as! ConfigDetailCell1
        cell.valueTF.becomeFirstResponder()
        
        
        
    }
    
    func downloadbtntpdForDatabaseValues(cell: ConfigDetailCell1){
        let indexPath = configDetailsTableview.indexPath(for: cell)
        let dict:NSDictionary = self.listArray?.object(at: indexPath!.row) as! NSDictionary
        downloadDatabaseValues(dict: dict,cell: cell)
    }
    
    func downloadDatabaseValues( dict:NSDictionary, cell:ConfigDetailCell1){
        
        var globalKey = ""
        let valuesArray:NSMutableArray = NSMutableArray.init()
        
        if let jsonDictioanry:NSMutableDictionary = dict.object(forKey: "source") as! NSMutableDictionary?   {
            
            if let conditionsDictionary:NSMutableDictionary = jsonDictioanry.object(forKey: "conditions") as! NSMutableDictionary?{
                if let subquery:NSMutableDictionary = conditionsDictionary.object(forKey: "subquery") as! NSMutableDictionary?{
                    
                    if let query:NSMutableDictionary = subquery.object(forKey: "query") as! NSMutableDictionary?{
                        if let subConditions:NSMutableDictionary = query.object(forKey: "conditions") as! NSMutableDictionary?{
                            if var device_id:NSString = subConditions.object(forKey:"device_id") as! NSString?{
                                device_id = NSString(format:"%s", self.selected_device_id!)
                                subConditions.setValue(device_id, forKey: "device_id")
                            }
                            query.setValue(subConditions, forKey: "conditions")
                        }
                        subquery.setValue(query, forKey: "query")
                    }
                    conditionsDictionary.setValue(subquery, forKey: "subquery")
                }
                jsonDictioanry.setValue(conditionsDictionary, forKey: "conditions")
            }
            
            print(jsonDictioanry);
            
            let token:NSString = UserDefaults.standard.object(forKey: TKConstants.TK_TOKEN_CONSTANT) as! NSString
            let url = URL(string: TKConstants.BASE_URL + TKConstants.CONFIGURATIONS_DATABASE_VALUES)!
            
            let dataManager = TKDataManager()
            dataManager.updateInSilentMode(url: url as NSURL, jsonParameters: jsonDictioanry, token:token, httpMethod: "POST", viewController: self, completionHandler: { (success, jsonDictionary1, message, token) in
                
                if success {
                    
                    DispatchQueue.main.async {
                        if let dataArray:NSArray = jsonDictionary1.object(forKey: "data") as? NSArray{
                            for var dataDict in dataArray{
                                let dict1 = dataDict as! NSDictionary
                                globalKey = dict1.allKeys[0] as! String
                                if let value = dict1.object(forKey: globalKey){
                                    
                                    if value is Int {
                                        let valueStr = NSString(format: "%d`", value as! CVarArg)
                                        valuesArray.add(valueStr)
                                    }
                                    else if value is Float {
                                        let valueStr = NSString(format: "%f`", value as! CVarArg)
                                        valuesArray.add(valueStr)
                                    }
                                    else if value is Double {
                                        let valueStr = NSString(format: "%f`", value as! CVarArg)
                                        valuesArray.add(valueStr)
                                    }else{
                                        valuesArray.add(value)
                                    }
                                }
                                
                            }

                            var selectedItem:String?
                            if let strSelected = cell.valueTF.selectedItem {
                                selectedItem = strSelected
                            }
                            
                            if valuesArray.count>0 {
                                
                                let DDArray:NSArray? = valuesArray as NSArray
                                cell.valueTF.itemList = DDArray as! [String]?
                                
                                if selectedItem != nil {
                                    cell.valueTF.selectedItem = selectedItem
                                }else{
                                    cell.valueTF.selectedItem = DDArray?[0] as? String
                                }
                                cell.valueTF.becomeFirstResponder()
                            }
                            
                            cell.databaseValuesDownloadBtn.isHidden = true;
                            cell.databaseValuesDownloadBtn.isEnabled = false;
                            
                            
                        }
                    }
                }
            })
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
    
    @IBAction func saveBtnTpd(_ sender: Any) {
        
        
        
    }
}
