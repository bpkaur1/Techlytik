//
//  SiteInformationCustomCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

class SiteInformationCustomCell: UITableViewCell {

    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 3.0;
    
    @IBOutlet var wellIdentifierTFs: [UITextField]!
    @IBOutlet var surfaceLocationTFs: [UITextField]!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        for TF:UITextField in self.wellIdentifierTFs {
            addCornerRadiusToView(View: TF)
        }
        
        for TF:UITextField in self.surfaceLocationTFs {
            addCornerRadiusToView(View: TF)
        }
    }

    func addCornerRadiusToView(View:Any?) {
        let btnView:UITextField = View as! UITextField
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
