//
//  GeofencePresenter.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import MapKit
import SystemConfiguration.CaptiveNetwork

protocol GeofenceImplement {
    
    @discardableResult func checkUpdateGeofenceStatus() -> Bool
    func onViewDidLoad(view: GeofenceViewImplement)
    func getGeofence() -> GeofenceModel?
    func updateGeofence(_ geofence: GeofenceModel?)
    func isInsideGeofenceArea(currentLocation: CLLocationCoordinate2D, geofence: GeofenceModel?) -> Bool
    func isMatchWifiName(geofence: GeofenceModel, currentWifiName: String) -> Bool
    func getWiFiSsid() -> String?
}

class GeofencePresenter: GeofenceImplement {
    
    private weak var view: GeofenceViewImplement?
    private let service: GeofenceService
    
    init(service: GeofenceService) {
        self.service = service
    }
    
    func onViewDidLoad(view: GeofenceViewImplement) {
        self.view = view
        self.updateGeofence(nil)
    }
    
    func getGeofence() -> GeofenceModel? {
        return service.getGeofence()
    }
    
     func updateGeofence(_ geofence: GeofenceModel?) {
        service.updateGeofence(geofence)
        self.view?.updateGeofenceInMap(geofence: geofence)
        self.view?.updateGeofenceStatus(geofence: geofence)
    }
    
    @discardableResult
    func checkUpdateGeofenceStatus() -> Bool {
        guard let geofence = service.getGeofence() else { return false }
        self.view?.updateGeofenceStatus(geofence: geofence)
        return true
    }
    
    func isInsideGeofenceArea(currentLocation: CLLocationCoordinate2D, geofence: GeofenceModel?) -> Bool {
        guard let geofence = geofence else { return false }
        let region = CLCircularRegion(center: geofence.coordinate, radius: geofence.radius, identifier: geofence.description)
        return region.contains(currentLocation)
    }
    
    func isMatchWifiName(geofence: GeofenceModel, currentWifiName: String = "") -> Bool {
        let wifiName = geofence.wifiName
        return !wifiName.isEmpty && currentWifiName == wifiName
    }
}

extension GeofencePresenter {

    public func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
}

