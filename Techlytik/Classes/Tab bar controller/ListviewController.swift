//
//  ListviewController.swift
//  Techlytik
//
//  Created by mac new on 7/14/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import UIKit

class ListviewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: IBOutlets
    @IBOutlet weak var listTableView: UITableView!
    
    
    
    //MARK: Global Variables
    let CELL_IDENTIFIER = "ListCustomCell"
    let CELL_HEIGHT:CGFloat = 135.0
    
    var listArray:NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "LIST"

        // Add Add & Search Button on navigation
        let adBarButtons = NavigationBarButtonActions()
        adBarButtons.AddBarButtons(navCont: self.navigationController!, navItem: self.navigationItem)
        
        loadInitialData()
        prepareUserInterface()
    }
    
    func loadInitialData() {
        listArray = NSMutableArray.init()
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
        listArray?.add("pass in list DAO")
    }
    
    func prepareUserInterface()
    {
        self.listTableView.register(UINib.init(nibName: CELL_IDENTIFIER, bundle: nil), forCellReuseIdentifier: CELL_IDENTIFIER)
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    //MARK: UITableview delegate methods
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (listArray?.count)!
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row >= 4 {
            return 119;
        }
        else{
            return CELL_HEIGHT
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell:ListCustomCell? = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER) as! ListCustomCell?
        
        if indexPath.row >= 4 {
            cell?.backgroundImage.image = UIImage(named: "\(indexPath.row-2).png");
        }else if indexPath.row >= 3 {
            cell?.backgroundImage.image = UIImage(named: "\(indexPath.row-2).png");
        }else{
            cell?.backgroundImage.image = UIImage(named: "\(indexPath.row).png");
        }
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        return cell!
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        _ = self.performSegue(withIdentifier: "ConfigSegue", sender: self)
    }

}
