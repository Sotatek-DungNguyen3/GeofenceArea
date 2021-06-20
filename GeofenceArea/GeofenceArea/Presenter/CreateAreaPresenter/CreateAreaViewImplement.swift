//
//  CreateAreaPresenter.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 20/06/2021.
//

import Foundation

protocol CreateAreaImplement {
    func onViewDidLoad(view: CreateAreaViewImplement)
    @discardableResult func loadGeofence() -> GeofenceModel?
}

class CreateAreaPresenter: CreateAreaImplement {
    
    private weak var view: CreateAreaViewImplement?
    private let service: GeofenceService
    
    init(service: GeofenceService) {
        self.service = service
    }
    
    func onViewDidLoad(view: CreateAreaViewImplement) {
        self.view = view
    }
    
    @discardableResult
    func loadGeofence() -> GeofenceModel? {
        guard let geofence = service.getGeofence() else { return nil}
        self.view?.updateUIWithModel(geofence)
        return geofence
    }
}
