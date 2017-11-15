//
//  groupTableViewCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 9/24/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

protocol groupTableViewCellProtocol:class {
    func detailBtnTpdForIndex(index:Int)
}

class groupTableViewCell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var icn_height_constraint: NSLayoutConstraint!
    @IBOutlet weak var icn_width_constraint: NSLayoutConstraint!
    @IBOutlet weak var icn_leading_constraint: NSLayoutConstraint!
    
    weak var delegate:groupTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func plusBtnTpd(_ sender: Any) {
        let btn:UIButton = sender as! UIButton
        
        self.delegate?.detailBtnTpdForIndex(index: btn.tag)
    }
}





