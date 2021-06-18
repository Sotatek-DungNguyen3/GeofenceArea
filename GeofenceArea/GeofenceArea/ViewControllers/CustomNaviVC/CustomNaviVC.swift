//
//  CustomNaviVC.swift
//  GeofenceArea
//
//  Created by Nguyen Tan Dung on 18/06/2021.
//

import UIKit

class CustomNaviVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.delegate = self
    }
    
    func setupView() {
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = Constants.Color.navigationBar
        let titleDict: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                        .font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
        self.navigationBar.titleTextAttributes = titleDict
        self.navigationBar.tintColor = UIColor.white
    }

}

extension CustomNaviVC: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        if let currentVC = self.topViewController {
            let backImage = UIImage(named: "ic_arrow_back")?.withInsets(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
            currentVC.navigationController?.navigationBar.backIndicatorImage = backImage
            currentVC.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
            let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            backButton.isAccessibilityElement = true
            backButton.accessibilityLabel = "backButtonNavigation"
            currentVC.navigationItem.backBarButtonItem = backButton
        }
    }
}
