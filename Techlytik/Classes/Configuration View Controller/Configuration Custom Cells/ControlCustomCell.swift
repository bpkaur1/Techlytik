//
//  ControlCustomCell.swift
//  Techlytik
//
//  Created by Mati ur Rab on 7/15/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

import UIKit

protocol ControlCustomCellProtocol:class {
    func cloneAllSetPointsAPICall(cell:ControlCustomCell)
}

class ControlCustomCell: UITableViewCell {

    //MARK: List of constants
    let CORNER_RADIUS:CGFloat = 5.0;
     weak var delegate:ControlCustomCellProtocol?
    
    
    @IBOutlet weak var selectedDeviceTF: IQDropDownTextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var AckORClearAlarmsBtn: UIButton!
    @IBOutlet weak var shutDownBtn: UIButton!
    @IBOutlet weak var cloneAllSetPoints: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addCornerRadiusToView(View: self.cloneAllSetPoints)
        
        addCornerRadiusToView(View: self.startBtn)
        addCornerRadiusToView(View: self.AckORClearAlarmsBtn)
        addCornerRadiusToView(View: self.shutDownBtn)
        
        addCornerRadiusToView(TF: self.selectedDeviceTF)
    }

    func addCornerRadiusToView(TF:UITextField?) {
        
        TF?.layer.cornerRadius = CORNER_RADIUS;
        TF?.layer.borderWidth = 0.5;
        TF?.clipsToBounds = true
    }
    
    func addCornerRadiusToView(View:Any?) {
        let btnView:UIButton = View as! UIButton
        btnView.layer.cornerRadius = CORNER_RADIUS;
        btnView.layer.borderWidth = 0.5;
        btnView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cloneAllSetPointsTpd(_ sender: Any) {
        self.delegate?.cloneAllSetPointsAPICall(cell: self)
    }
    @IBAction func startBtnTpd(_ sender: Any) {
    }
    @IBAction func AckORClearAlarmsBtnTpd(_ sender: Any) {
    }
    @IBAction func shutDownBtnTpd(_ sender: Any) {
    }
}
