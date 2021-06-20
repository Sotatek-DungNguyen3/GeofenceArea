//
//  AppDelegate.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability: Reachability?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.setRoot(type: .mapVC)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        reachability?.stopNotifier()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        reachability = application.setupReachability()
    }
}
