//
//  AppPreferences.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import Foundation

class AppPreferences {
    
    static let instance = AppPreferences()
    private let userDefaults: UserDefaults
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    var geofenceModel: GeofenceModel? {
        get {
            guard let savedData = userDefaults.data(forKey: Constants.Key.keyGeofenceModel) else { return nil }
            let decoder = JSONDecoder()
            if let savedGeofence = try? decoder.decode(GeofenceModel.self, from: savedData) as GeofenceModel {
                return savedGeofence
            }
            return nil
        }
        
        set {
            do {
                let encodedObject = try JSONEncoder().encode(newValue)
                userDefaults.set(encodedObject, forKey: Constants.Key.keyGeofenceModel)
                userDefaults.synchronize()
            } catch {
                print("Can't save GeofenceModel")
            }
        }
    }
}
