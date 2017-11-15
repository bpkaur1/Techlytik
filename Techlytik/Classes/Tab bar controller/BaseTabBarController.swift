//
//  BaseTabBarController.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/16/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

     @IBInspectable var defaultIndex: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedIndex = defaultIndex
    }

}
