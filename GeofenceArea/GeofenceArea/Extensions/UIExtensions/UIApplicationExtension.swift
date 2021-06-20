//
//  UIApplicationExtension.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 20/06/2021.
//

import UIKit
import Reachability

extension UIApplication {
    
    func setupReachability() -> Reachability {
        let reachability = try! Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        return reachability
    }

    @objc func reachabilityChanged(note: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.NotificationKey.keyNotification), object: nil)
    }
}
