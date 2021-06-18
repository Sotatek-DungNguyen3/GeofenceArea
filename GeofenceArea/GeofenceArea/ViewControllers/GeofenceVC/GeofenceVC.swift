//
//  GeofenceVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

class GeofenceVC: BaseVC {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    
    override func setupView() {
        super.setupView()
        statusLabel.text = ""
        wifiNameLabel.text = ""
    }

}
