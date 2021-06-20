//
//  Application.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit

class Application: NSObject {
    
    static let shared: Application = Application()
    let application = UIApplication.shared
}

extension Application {
    
    var delegate: AppDelegate {
        return application.delegate as! AppDelegate
    }
    
    var window: UIWindow? {
        return delegate.window
    }
    
    private(set) var root: UIViewController? {
        set {
            window?.rootViewController = newValue
        }
        get {
            return window?.rootViewController
        }
    }
    
    func setRoot(type: VCType, completion: (() -> Void)? = nil) {
        let vc = viewController(type: type)
        guard let window = self.window else { return }
        root = vc
        window.makeKeyAndVisible()
        completion?()
    }
    
    private func viewController(type: VCType) -> UIViewController {
        switch type {
        case .mapVC:
            let service = GeofenceService()
            let presenter = GeofencePresenter(service: service)
            let geofenceVC = GeofenceVC(presenter: presenter)
            let nav = CustomNaviVC(rootViewController: geofenceVC)
            nav.setNavigationBarHidden(false, animated: false)
            return nav
        }
    }
}
