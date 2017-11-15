//
//  TermsAndPrivacyPolicy.swift
//  Techlytik
//
//  Created by mac new on 8/16/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
class TermsAndPrivacyPolicy: UIViewController
{
    let leftBarButton = UIBarButtonItem()

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func MoveBack(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }

}
