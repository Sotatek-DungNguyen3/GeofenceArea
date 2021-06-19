//
//  CreateAreaVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

class CreateAreaVC: BaseVC {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var contentTable: UITableView!
    
    private let numberCell = 2
    
    override func setupView() {
        super.setupView()
        self.title = screenName
        contentTable.register(UINib(nibName: "CreateAreaCell", bundle: nil), forCellReuseIdentifier: "CreateAreaCell")
    }
    
    override func setupNavigation() {
        super.setupNavigation()
        screenName = "Create area"
        self.title = screenName
        let createButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(tappedCreate))
        createButton.isAccessibilityElement = true
        createButton.accessibilityLabel = "CreateComplete"
        navigationItem.rightBarButtonItem = createButton
    }
    
    @IBAction func currentLocationButtonClicked(_ sender: Any) {
        dismissKeyboard()
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedCreate() {
        dismissKeyboard()
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateAreaVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = contentTable.dequeueReusableCell(withIdentifier: "CreateAreaCell", for: indexPath) as? CreateAreaCell else {
            fatalError("DequeueReusableCell failed while casting")
        }
        cell.setupCell(cellType: indexPath.row == 0 ? .radius : .wifiName)
        return cell
    }
}
