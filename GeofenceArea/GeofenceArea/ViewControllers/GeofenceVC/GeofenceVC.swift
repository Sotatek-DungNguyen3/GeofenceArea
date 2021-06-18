//
//  GeofenceVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

protocol GeofenceViewPresenter: class {
    func updateGeofenceInMap(geofence: GeofenceModel?)
    func updateGeofenceStatus(geofence: GeofenceModel?)
    func startMonitoring(geofence: GeofenceModel?)
}

class GeofenceVC: BaseVC {
   
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var presenter: GeofencePresenterImplement?
    
    init() {
        super.init(nibName: "GeofenceVC", bundle: nil)
    }
    
    init(presenter: GeofencePresenterImplement) {
        self.presenter = presenter
        super.init(nibName: "GeofenceVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setupView() {
        super.setupView()
        mapView.delegate = self
        presenter?.onViewDidLoad(view: self)
        setupNavigation()
        statusLabel.text = ""
        wifiNameLabel.text = ""
    }
    
    private func setupNavigation() {
        self.title = "Geofence Area"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "my_location_white"), style: .plain, target: self, action: #selector(tappedMyLocation))
        let editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(tappedEdit))
        editButton.isAccessibilityElement = true
        editButton.accessibilityLabel = "EditButton"
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeWifi), name: NSNotification.Name(rawValue: Constants.NotificationKey.keyNotification), object: nil)
    }
    
    @objc func tappedMyLocation() {
        mapView.zoomToUserLocation()
    }
    
    @objc func tappedEdit() {
        
    }
    
    @objc func didChangeWifi() {
        presenter?.checkUpdateGeofenceStatus()
    }

}

extension GeofenceVC: GeofenceViewPresenter {
    
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
        statusLabel.textColor = isInsideArea ? .blue : .red
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

extension GeofenceVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.zoomToUserLocation()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            self.presentAlert(title: "Need permission", message: "Please allow location access in Settings", actionTitle: "Go to Settings", actionHandler: { action in
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            })
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        presenter?.checkUpdateGeofenceStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        presenter?.checkUpdateGeofenceStatus()
    }
    
}

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
