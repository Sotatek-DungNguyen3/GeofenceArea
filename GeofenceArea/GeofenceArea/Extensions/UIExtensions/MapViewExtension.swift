//
//  MapViewExtension.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import MapKit

extension MKMapView {
    func zoomToUserLocation() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
    
    func zoomToUserLocation(_ locationManager: CLLocationManager, animated: Bool = true) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: animated)
    }
    
   func zoomToLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        setRegion(region, animated: true)
    }
    
    func addGeofence(geofence: GeofenceModel) {
        addOverlay(MKCircle(center: geofence.coordinate, radius: geofence.radius))
        addAnnotation(geofence)
    }
    
   func removeAllGeofences() {
        removeAnnotations(annotations)
        removeOverlays(overlays)
    }
}
