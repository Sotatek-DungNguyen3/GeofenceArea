//
//  CreateAreaVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

protocol CreateAreaViewImplement: class {
    func updateUIWithModel(_ geofence: GeofenceModel)
}

protocol CreateAreaPresenterDelegate: class {
    func tappedCreateAreaViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String)
}

class CreateAreaVC: BaseVC {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var contentTable: UITableView!
    
    private var locationManager = CLLocationManager()
    weak var delegate: CreateAreaPresenterDelegate?
    private var geofenceModel: GeofenceModel?
    private var presenter: CreateAreaImplement?
    private var wifiName = ""
    private var radius = ""
    
    private let numberCell = 2
    
    init() {
        super.init(nibName: "CreateAreaVC", bundle: nil)
    }
    
    init(presenter: CreateAreaImplement) {
        self.presenter = presenter
        super.init(nibName: "CreateAreaVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setupView() {
        super.setupView()
        self.title = screenName
        contentTable.register(UINib(nibName: "CreateAreaCell", bundle: nil), forCellReuseIdentifier: "CreateAreaCell")
        setupLocation()
        presenter?.onViewDidLoad(view: self)
        hideKeyboardWhenTappedAround()
        presenter?.loadGeofence()
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
    
    private func setupLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        mapView.zoomToUserLocation(locationManager, animated: false)
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func currentLocationButtonClicked(_ sender: Any) {
        dismissKeyboard()
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedCreate() {
        dismissKeyboard()
        let radius = Double(radius) ?? 1000.0
        let coordinate = mapView.centerCoordinate
        self.delegate?.tappedCreateAreaViewController(coordinate: coordinate, radius: radius, wifiName: wifiName)
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
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 100.0, longitude: 100.0)
        cell.setupCell(cellType: indexPath.row == 0 ? .radius : .wifiName, geofenceModel: geofenceModel ?? GeofenceModel(coordinate: defaultCoordinate, radius: 1000, wifiName: ""))
        cell.onDidEndEditing = { [weak self] (text) in
            if indexPath.row == 0 {
                self?.radius = text
            } else {
                self?.wifiName = text
            }
        }
        return cell
    }
}

extension CreateAreaVC: CreateAreaViewImplement {
    func updateUIWithModel(_ geofence: GeofenceModel) {
        geofenceModel = geofence
        mapView.zoomToLocation(coordinate: geofence.coordinate)
    }
}

extension CreateAreaVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
        case .denied, .restricted:
            self.showAlert(title: "Need permission", message: "Please allow location access in Settings", actionTitle: "Go to Settings", actionHandler: { action in
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            })
        default:
            break
        }
    }
}
