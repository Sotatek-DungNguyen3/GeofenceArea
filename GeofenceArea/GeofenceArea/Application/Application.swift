//
//  Application.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import Foundation

import UIKit

class Application: NSObject {
    
    static let shared: Application = Application()
    
    let application = UIApplication.shared
}


// MARK: - Window
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
    
    func setRoot(_ viewController: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil) {
        guard let window = self.window else { return }
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.root = viewController
                UIView.setAnimationsEnabled(oldState)
                window.makeKeyAndVisible()
            }, completion: { (_) in
                completion?()
            })
        } else {
            root = viewController
            window.makeKeyAndVisible()
            completion?()
        }
    }
    
    public func switchRoot(type: VCType, animated: Bool = false, completion: (() -> Void)? = nil) {
        let vc = viewController(type: type)
        setRoot(vc, animated: animated, completion: completion)
    }
    
    private func viewController(type: VCType) -> UIViewController {
        switch type {
        case .mapVC:
            let service = GeofenceService()
            let presenter = GeofencePresenterImplement(service: service)
            let geofenceVC = GeofenceVC(presenter: presenter)
            let nav = CustomNaviVC(rootViewController: geofenceVC)
            nav.setNavigationBarHidden(false, animated: false)
            return nav
        }
    }
}
