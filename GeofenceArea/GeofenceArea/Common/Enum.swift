//
//  Enum.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import Foundation


enum VCType {
    case mapVC
}

enum CellType {
    case radius
    case wifiName
}

enum CodingKeys: String, CodingKey {
    case lat, long, radius, wifiName
}
