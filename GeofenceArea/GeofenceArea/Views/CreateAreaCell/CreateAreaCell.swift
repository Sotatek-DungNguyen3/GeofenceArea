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
    
    var onDidEndEditing: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(cellType: CellType, geofenceModel: GeofenceModel) {
        let isRadiusCell = cellType == .radius
        contentTextField.delegate = self
        nameLabel.text = isRadiusCell ? "Radius (meter):" : "Wifi name:"
        contentTextField.keyboardType = isRadiusCell ? .numberPad : .default
        let radius = geofenceModel.radius != 0 ? "1000.0" : String(geofenceModel.radius)
        contentTextField.text = isRadiusCell ? radius : geofenceModel.wifiName
        contentTextField.placeholder = isRadiusCell ? "Enter geofence Radius in meters" : "Enter name of your wifi "
    }
}

extension CreateAreaCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        onDidEndEditing?(text)
    }
}
