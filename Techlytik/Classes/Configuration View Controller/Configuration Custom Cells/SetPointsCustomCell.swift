//
//  SetPointsCustomCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

protocol SetPointsCustomCellProtocol:class {
    func detailBtnTpdForIndex(index:Int)
}

class SetPointsCustomCell: UITableViewCell {

    weak var delegate:SetPointsCustomCellProtocol?
    
    @IBOutlet var plusBtns: [UIButton]!
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
