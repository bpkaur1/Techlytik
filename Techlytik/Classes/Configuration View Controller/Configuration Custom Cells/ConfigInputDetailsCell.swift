//
//  ConfigInputDetailsCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 9/24/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

class ConfigInputDetailsCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var valueTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
