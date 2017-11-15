//
//  InitialViewControllerSplash.swift
//  Techlytik
//
//  Created by Mati ur Rab on 8/30/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import Foundation
import UIKit

class InitialViewControllerSplash: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        
        let jeremyGif = UIImage.gifImageWithName("tech")
        let imageView = UIImageView(image: jeremyGif)
        imageView.frame = CGRect(x: (self.view.frame.size.width - 308)/2, y: (self.view.frame.size.height - 118)/2, width: 308, height: 118)
        view.addSubview(imageView)
        self.perform(#selector(InitialViewControllerSplash.showLoginScreen), with: nil, afterDelay: 5)
    }
    
    func showLoginScreen()
    {
        self.performSegue(withIdentifier: TKConstants.TK_SHOW_LOGIN_SCREEN_FROM_SPLASH, sender: self)
    }
}

