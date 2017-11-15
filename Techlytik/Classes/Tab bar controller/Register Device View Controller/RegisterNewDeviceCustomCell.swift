//
//  RegisterNewDeviceCustomCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

protocol RegisterNewDeviceCustomCellProtocol:class {
    func connectToNewDeviceTpd(sender: RegisterNewDeviceCustomCell)
}

class RegisterNewDeviceCustomCell: UITableViewCell {
    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
    
    weak var delegate:RegisterNewDeviceCustomCellProtocol?
    
    @IBOutlet weak var connectToNewDeviceBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        addCornerRadiusToView(View: self.connectToNewDeviceBtn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
    }
    
    @IBAction func connectToNewDeviceBtnTpd(_ sender: Any) {
        self.delegate?.connectToNewDeviceTpd(sender: self);
    }
}
