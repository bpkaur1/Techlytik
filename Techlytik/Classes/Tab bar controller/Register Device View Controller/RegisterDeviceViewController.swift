//
//  RegisterDeviceViewController.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation

class RegisterDeviceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RegisterNewDeviceCustomCellProtocol {
    
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    //MARK: IBOutlets
    @IBOutlet weak var registerDeviceTable: UITableView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    //MARK: Global Variables
    let REGISTER_NEW_DEVICE_CELL_IDENTIFIER = "RegisterNewDeviceCustomCell"
    let REGISTER_NEW_DEVICE_CELL_HEIGHT:CGFloat = 52.0
    
    let DEVICE_INFORMATION_CELL_IDENTIFIER = "DeviceInformationCustomCell"
    let DEVICE_INFORMATION_INFO_CELL_HEIGHT:CGFloat = 56.0
    
    let SITE_INFORMATION_CELL_IDENTIFIER = "SiteInformationCustomCell"
    let SITE_INFORMATION_CELL_HEIGHT:CGFloat = 217.0
    
    let HEADER_HEIGHT:CGFloat = 30.0

    var listArray:NSMutableArray?
    var headerTitles:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadInitialData()
        prepareUserInterface()
        
    }
    
    func loadInitialData() {
        headerTitles = NSArray.init(objects: "Register New Device","Device Information", "Site Information")
        
        addCornerRadiusToView(View: self.registerBtn)
    }
    
    func prepareUserInterface(){
        self.registerDeviceTable.register(UINib.init(nibName: REGISTER_NEW_DEVICE_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: REGISTER_NEW_DEVICE_CELL_IDENTIFIER)
        
        self.registerDeviceTable.register(UINib.init(nibName: DEVICE_INFORMATION_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: DEVICE_INFORMATION_CELL_IDENTIFIER)
        
        self.registerDeviceTable.register(UINib.init(nibName: SITE_INFORMATION_CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: SITE_INFORMATION_CELL_IDENTIFIER)
        
        self.registerDeviceTable.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }
    
    @IBAction func registerBtnTpd(_ sender: Any){
        let alert = UIAlertController(title: "Registered", message: "API not available yet", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UITableview delegate methods
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return HEADER_HEIGHT;
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        var height:CGFloat = 46.0;
        
        switch indexPath.section {
        case 0:
            height = REGISTER_NEW_DEVICE_CELL_HEIGHT
            break
        case 1:
            height = DEVICE_INFORMATION_INFO_CELL_HEIGHT
            break
        case 2:
            height = SITE_INFORMATION_CELL_HEIGHT
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
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell:UITableViewCell?
        
        switch indexPath.section {
        case 0:
            let cell1:RegisterNewDeviceCustomCell = (tableView.dequeueReusableCell(withIdentifier: REGISTER_NEW_DEVICE_CELL_IDENTIFIER) as! RegisterNewDeviceCustomCell?)!
            cell1.delegate = self
            cell = cell1
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: DEVICE_INFORMATION_CELL_IDENTIFIER) as! DeviceInformationCustomCell?
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: SITE_INFORMATION_CELL_IDENTIFIER) as! SiteInformationCustomCell?
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: REGISTER_NEW_DEVICE_CELL_IDENTIFIER) as! RegisterNewDeviceCustomCell?
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    }
    
    //MARK: Register New Device Custom Cell delegate methods
    func connectToNewDeviceTpd(sender: RegisterNewDeviceCustomCell){
        let alert = UIAlertController(title: "Bluetooth Required", message: "Connect to device via bluetooth... (Not configured yet)", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
