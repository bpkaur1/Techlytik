//
//  TutorialViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 2/3/16.
//  Copyright © 2016 Seven Even. All rights reserved.
//

import UIKit

class ConnectToLocalDeviceViewController: UIViewController {

    
    @IBOutlet var pcDots: UIPageControl!
    @IBOutlet var containerView: UIView!
    
    var localDevicePageViewController: LocalDevicePageViewController? {
        didSet {
            localDevicePageViewController?.localDevicePageDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Connect To Local Device"
        
        pcDots.addTarget(self, action: #selector(ConnectToLocalDeviceViewController.didChangePageControlValue), for: .valueChanged)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let localDevicePageViewController = segue.destination as? LocalDevicePageViewController {
                        self.localDevicePageViewController = localDevicePageViewController
                    }
    }

    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    @objc func didChangePageControlValue()
    {
        localDevicePageViewController?.scrollToViewController(index: pcDots.currentPage)
    }
}

extension ConnectToLocalDeviceViewController: LocalDevicePageViewControllerDelegate {
    
    func localDevicePageViewController(localDevicePageViewController: LocalDevicePageViewController,
        didUpdatePageCount count: Int) {
        pcDots.numberOfPages = count
    }
    
    func localDevicePageViewController(localDevicePageViewController: LocalDevicePageViewController,
        didUpdatePageIndex index: Int) {
        pcDots.currentPage = index
    }
    
}
