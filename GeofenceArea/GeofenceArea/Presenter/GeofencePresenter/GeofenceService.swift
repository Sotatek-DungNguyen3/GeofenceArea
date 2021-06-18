//
//  GeofenceService.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import Foundation

protocol GeofenceServiceImplement {
    func getGeofence() -> GeofenceModel?
    func updateGeofence(_ geofence: GeofenceModel?)
}

public class GeofenceService: GeofenceServiceImplement {
    public func getGeofence() -> GeofenceModel?{
        return AppPreferences.instance.geofenceModel
    }
    
    public func updateGeofence(_ geofence: GeofenceModel?) {
        AppPreferences.instance.geofenceModel = geofence
    }
}
