//
//  BaseVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit

class BaseVC: UIViewController {
    
    var screenName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        setupNavigation()
    }
    
    func setupNavigation() {
        
    }

}
