//
//  ProfilePhotoCustomCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit


protocol ProfilePhotoCustomCellProtocol:class {
    func photoEditTpd(sender: ProfilePhotoCustomCell)
}

class ProfilePhotoCustomCell: UITableViewCell {

    weak var delegate:ProfilePhotoCustomCellProtocol?
    
    @IBOutlet weak var profileEditBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func profileEditBtnTpd(_ sender: Any) {
        delegate?.photoEditTpd(sender: self)
    }
}
