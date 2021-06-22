//
//  GeofenceVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

protocol GeofenceViewImplement: class {
    func updateGeofenceInMap(geofence: GeofenceModel?)
    func updateGeofenceStatus(geofence: GeofenceModel?)
    func startMonitoring(geofence: GeofenceModel?)
}

class GeofenceVC: BaseVC {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var presenter: GeofencePresenter?
    
    init() {
        super.init(nibName: "GeofenceVC", bundle: nil)
    }
    
    init(presenter: GeofencePresenter) {
        self.presenter = presenter
        super.init(nibName: "GeofenceVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
    }
    
    override func setupView() {
        super.setupView()
        screenName = "Geofence area"
        self.title = screenName
        setupLocation()
        setupObserver()
        presenter?.onViewDidLoad(view: self)
        statusLabel.text = ""
        wifiNameLabel.text = ""
    }
    
    override func setupNavigation() {
        super.setupNavigation()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_current_location"), style: .plain, target: self, action: #selector(tappedMyLocation))
        let createAreaButton = UIBarButtonItem(image: UIImage(named: "ic_open_add_geofence"), style: .plain, target: self, action: #selector(tappedCreateArea))
        createAreaButton.isAccessibilityElement = true
        createAreaButton.accessibilityLabel = "createAreaButton"
        navigationItem.rightBarButtonItem = createAreaButton
    }
    
    private func setupLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            mapView.zoomToUserLocation(locationManager, animated: false)
            DispatchQueue.main.async { [weak self] in
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeWifi), name: NSNotification.Name(rawValue: Constants.NotificationKey.keyNotification), object: nil)
    }
    
    // Move to current location
    @objc func tappedMyLocation() {
        mapView.zoomToUserLocation()
    }
    
    // Open Create geofence area screen
    @objc func tappedCreateArea() {
        let service = GeofenceService()
        let presenter = CreateAreaPresenter(service: service)
        let createAreaVC = CreateAreaVC(presenter: presenter)
        createAreaVC.delegate = self
        self.navigationController?.pushViewController(createAreaVC, animated: true)
    }
    
    // Check if wifi status is changed
    @objc func didChangeWifi() {
        presenter?.checkUpdateGeofenceStatus()
    }

}

// MARK: - GeofenceViewImplement
extension GeofenceVC: GeofenceViewImplement {
    func updateGeofenceInMap(geofence: GeofenceModel?) {
        guard let geofence = geofence else { return }
        wifiNameLabel.text = "Wifi name:" + "\(geofence.wifiName)"
        mapView.removeAllGeofences()
        mapView.addGeofence(geofence: geofence)
        startMonitoring(geofence: geofence)
    }
    
    func updateGeofenceStatus(geofence: GeofenceModel?) {
        guard let geofence = geofence, let presenter = presenter else { return }
        let currentCoordinate = mapView.userLocation.coordinate
        let currentWifiName = presenter.getWiFiSsid() ?? ""
        let isInsideCircle = presenter.isInsideGeofenceArea(currentLocation: currentCoordinate, geofence: geofence)
        let isMatchWifi = presenter.isMatchWifiName(geofence: geofence, currentWifiName: currentWifiName)
        let isInsideArea = isInsideCircle || isMatchWifi
        statusLabel.text = "Status: \(isInsideArea ? "Inside" : "Outside")"
    }
    
    func startMonitoring(geofence: GeofenceModel?) {
        if let geofence = geofence, CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.wifiName)
            region.notifyOnExit = true
            region.notifyOnEntry = true
            locationManager.startMonitoring(for: region)
        }
    }
}

// MARK: - LocationManagerDelegate
extension GeofenceVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.zoomToUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.showAlert(title: "Permission denied", message: "Please go to Settings and allow location access", actionTitle: "Go to Settings", actionHandler: { action in
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            })
        case .notDetermined:
            print("Location status not determined.")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        presenter?.checkUpdateGeofenceStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        presenter?.checkUpdateGeofenceStatus()
    }
    
}

// MARK: - MKMapViewDelegate
extension GeofenceVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .orange
            circleRenderer.fillColor = UIColor.orange.withAlphaComponent(0.3)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - CreateAreaPresenterDelegate
extension GeofenceVC: CreateAreaPresenterDelegate {
    func tappedCreateAreaViewController(coordinate: CLLocationCoordinate2D, radius: Double, wifiName: String) {
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        let geofence = GeofenceModel(coordinate: coordinate, radius: clampedRadius, wifiName: wifiName)
        presenter?.updateGeofence(geofence)
    }
}
