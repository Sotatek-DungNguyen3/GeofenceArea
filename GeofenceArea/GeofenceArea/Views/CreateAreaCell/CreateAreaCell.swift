//
//  CreateAreaCell.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 19/06/2021.
//

import UIKit

class CreateAreaCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(cellType: CellType) {
        let isRadiusCell = cellType == .radius
        nameLabel.text = isRadiusCell ? "Radius (meter):" : "Wifi name:"
        contentTextField.keyboardType = isRadiusCell ? .numberPad : .default
        contentTextField.text = isRadiusCell ? "1000" : ""
        contentTextField.placeholder = isRadiusCell ? "Enter geofence Radius in meters" : "Enter name of your wifi "
    }
}
