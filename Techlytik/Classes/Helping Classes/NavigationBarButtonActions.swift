//
//  NavigationBarFunctions.swift
//  Techlytik
//
//  Created by Waheguru on 09/11/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import UIKit

class NavigationBarButtonActions: UIViewController
{
    var navContr : UINavigationController!
    func AddBarButtons(navCont : UINavigationController , navItem : UINavigationItem!)
    {
        print(navCont)
        navContr = navCont
        let btnAdd = UIButton()
        btnAdd.setImage(UIImage(named: "add."), for: .normal)
        btnAdd.addTarget(self, action: #selector(NavigationBarButtonActions.OpenRegisterNewDevice), for: .touchUpInside)
        let leftBarBtn = UIBarButtonItem()
        leftBarBtn.customView = btnAdd
        navItem.leftBarButtonItem = leftBarBtn

        let btnSearch = UIButton()
        btnSearch.setImage(UIImage(named: "search."), for: .normal)
        let rightBarBtn = UIBarButtonItem()
        rightBarBtn.customView = btnSearch
        navItem.rightBarButtonItem = rightBarBtn
        btnSearch.addTarget(self, action: #selector(NavigationBarButtonActions.Search), for: .touchUpInside)
        
//        let viewNav = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
//        viewNav.backgroundColor = UIColor.yellow
//        navItem.titleView = viewNav
//
//        var btnAdd = UIButton()
//        btnAdd = UIButton(frame: CGRect(x: self.view.frame.size.width-50, y: 10, width: 30, height: 30))
//                btnAdd.setImage(UIImage(named: "add."), for: .normal)
//                btnAdd.addTarget(self, action: #selector(NavigationBarButtonActions.OpenRegisterNewDevice), for: .touchUpInside)
//        viewNav.addSubview(btnAdd)
//        viewFN.addSubview(button1)
//        viewFN.addSubview(button2)
//        viewFN.addSubview(button3)
        
    }
    
    func OpenRegisterNewDevice()
    {
        print(navContr)
        let newDevice = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "device") as! RegisterDeviceViewController
        navContr.pushViewController(newDevice, animated: true)
    }
    
    func Search()
    {
    }
}
