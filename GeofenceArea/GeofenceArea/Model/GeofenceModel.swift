//
//  GeofenceModel.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import MapKit

public class GeofenceModel: NSObject, Codable, MKAnnotation {
    public let coordinate: CLLocationCoordinate2D
    public let radius: CLLocationDistance
    public let wifiName: String
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, wifiName: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.wifiName = wifiName
    }
    
    // MARK: Codable
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let lat = try values.decode(Double.self, forKey: .lat)
        let long = try values.decode(Double.self, forKey: .long)
        coordinate = CLLocationCoordinate2DMake(lat, long)
        radius = try values.decode(Double.self, forKey: .radius)
        wifiName = try values.decode(String.self, forKey: .wifiName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .lat)
        try container.encode(coordinate.longitude, forKey: .long)
        try container.encode(radius, forKey: .radius)
        try container.encode(wifiName, forKey: .wifiName)
    }
}


