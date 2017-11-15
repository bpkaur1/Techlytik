//
//  ConfigDetailCell1.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

protocol ConfigDetailCell1Protocol:class {
    func dropDownTpdFor(tag: Int)
    func downloadbtntpdForDatabaseValues(cell: ConfigDetailCell1)
}

class ConfigDetailCell1: UITableViewCell {

    
    weak var delegate:ConfigDetailCell1Protocol?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: IQDropDownTextField!
    @IBOutlet weak var dropdownBtn: UIButton!
    @IBOutlet weak var databaseValuesDownloadBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        databaseValuesDownloadBtn.isHidden = true;
        databaseValuesDownloadBtn.isEnabled = false;
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func dropdownBtnpd(_ sender: Any) {
        let btn:UIButton = sender as! UIButton
        self.delegate?.dropDownTpdFor(tag: btn.tag)
    }
    
    @IBAction func databaseValuesDownloadBtnTpd(_ sender: Any) {
        self.delegate?.downloadbtntpdForDatabaseValues(cell: self)
    }
    
}
