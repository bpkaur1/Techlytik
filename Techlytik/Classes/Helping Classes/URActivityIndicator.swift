//
//  URActivityIndicator.swift
//  AppaTatt
//
//  Created by Harjot Harry on 12/18/16.
//  Copyright © 2016 Elfin Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class URActivityIndicator: NSObject {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    var activityIndicatorImageView: UIImageView = UIImageView()
    var loadingLbl1: UILabel = UILabel()
    var loadingLbl2: UILabel = UILabel()
    
    //add images to the array
    var imagesListArray     : [UIImage] = []
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     @param uiView - add activity indicator to this view
     */
    
    func showActivityIndicator(uiView: UIView )
    {
        //Constraint on container View
        let leftConstraint: NSLayoutConstraint = NSLayoutConstraint(item: uiView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        
        let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: uiView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        
        let rightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: uiView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0)
        
        let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: uiView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: container, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        
        //Constraint on loadingView View
        let centerX : NSLayoutConstraint = NSLayoutConstraint(item:loadingView, attribute: NSLayoutAttribute.centerX, relatedBy:.equal, toItem:container, attribute:.centerX, multiplier: 1.0, constant: 0)
        let centerY : NSLayoutConstraint = NSLayoutConstraint(item:loadingView, attribute: NSLayoutAttribute.centerY, relatedBy:.equal, toItem:container, attribute:.centerY, multiplier: 1.0, constant: 0)
        let height : NSLayoutConstraint = NSLayoutConstraint(item:loadingView, attribute: .height, relatedBy: .equal, toItem: nil, attribute:.height, multiplier: 1.0, constant:100)
        let width : NSLayoutConstraint = NSLayoutConstraint(item:loadingView, attribute: .width, relatedBy: .equal, toItem: nil, attribute:.width, multiplier: 1.0, constant:100)
        
        //Constraint on activityIndicator
        let centerX2 : NSLayoutConstraint = NSLayoutConstraint(item:activityIndicatorImageView, attribute:NSLayoutAttribute.centerX, relatedBy:.equal, toItem:loadingView, attribute:.centerX, multiplier: 1.0, constant: 0)
        let centerY2 : NSLayoutConstraint = NSLayoutConstraint(item:activityIndicatorImageView, attribute:NSLayoutAttribute.centerY, relatedBy:.equal, toItem:loadingView, attribute:.centerY, multiplier: 1.0, constant: 0)
        let height2 : NSLayoutConstraint = NSLayoutConstraint(item:activityIndicatorImageView, attribute:.height, relatedBy:.equal, toItem: nil, attribute:.height, multiplier: 1.0, constant:80)
        let width2 : NSLayoutConstraint = NSLayoutConstraint(item:activityIndicatorImageView, attribute:.width, relatedBy:.equal, toItem: nil, attribute:.width, multiplier: 1.0, constant:80)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(rgbValue: 0x000000, alpha: 0.6)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100) //In constraints defined constants for width & Height
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0xFFFFFF, alpha: 1.0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 15
        
        //use for loop
        for position in 0...7
        {
            let strImageName : String = "Image-\(position)"
            let image  = UIImage(named:strImageName)
            imagesListArray.append(image!)
        }
        self.activityIndicatorImageView.animationImages = imagesListArray;
        self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
        self.activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        self.activityIndicatorImageView.animationDuration = 0.5
        
        loadingView.addSubview(loadingLbl1)
        loadingView.addSubview(loadingLbl2)
        
        loadingView.addSubview(activityIndicatorImageView)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        
        uiView.addConstraints([leftConstraint,rightConstraint,topConstraint,bottomConstraint])
        loadingView.addConstraints([height,width])
        container.addConstraints([centerX,centerY])
        
        activityIndicatorImageView.addConstraints([height2,width2])
        container.addConstraints([centerX2,centerY2])
        self.activityIndicatorImageView.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        imagesListArray = []
        self.activityIndicatorImageView.animationDuration = 0.0
        activityIndicatorImageView.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
