//
//  AppDelegate.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let geofenceVC = GeofenceVC()
        let navi = UINavigationController(rootViewController: geofenceVC)
        navi.navigationBar.isHidden = true
        self.window = UIWindow()
        self.window?.makeKeyAndVisible()
        self.window!.rootViewController = navi
        return true
    }
}

