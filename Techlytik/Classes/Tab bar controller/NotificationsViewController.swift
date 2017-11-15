//
//  NotificationsViewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: IBOutlets
    @IBOutlet weak var notificationsTableView: UITableView!
    
    
    //MARK: Global Variables
    let CELL_IDENTIFIER = "NotificationCustonCell"
    let CELL_HEIGHT:CGFloat = 52.0
    
    var listArray:NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add Add & Search Button on navigation
        let adBarButtons = NavigationBarButtonActions()
        adBarButtons.AddBarButtons(navCont: self.navigationController!, navItem: self.navigationItem)
        
        loadInitialData()
        prepareUserInterface()
        
        self.navigationItem.title = "ALARM"
    }
    
    func loadInitialData()
    {
        listArray = NSMutableArray.init()
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
    }
    
    func prepareUserInterface()
    {
        self.notificationsTableView.register(UINib.init(nibName: "NotificationCustonCell", bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        self.notificationsTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //MARK: UITableview delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (listArray?.count)!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CELL_HEIGHT
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:NotificationCustonCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! NotificationCustonCell?
    
        if indexPath.row%2 == 0
        {
            cell?.backgroundImage.image = UIImage(named: "redAlarm.png");
        }
        else if(indexPath.row%3 == 0)
        {
            cell?.backgroundImage.image = UIImage(named: "grayAlarm.png");
        }
        else
        {
            cell?.backgroundImage.image = UIImage(named: "greenAlarm.png");
        }
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }

}
